import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/recipe.dart';
import '../providers/recipes.dart';

class EditRecipeScreen extends StatefulWidget {
  static const routeName = '/edit-recipe';

  @override
  _EditRecipeScreenState createState() => _EditRecipeScreenState();
}

class _EditRecipeScreenState extends State<EditRecipeScreen> {
  final _priceFocusNode = FocusNode();
  final _timeFocusNode = FocusNode();
  final _stepsFocusNode = FocusNode();
  final _ingredientsFocusNode = FocusNode();
  final _imageUrlController = TextEditingController();
  final _imageUrlFocusNode = FocusNode();
  final GlobalKey<FormState> _form = GlobalKey<FormState>();
  var _editedRecipe = Recipe(
    id: null,
    title: '',
    ingredients: '',
    steps: '',
    price: 0,
    time: 0,
    imageUrl: '',
  );

  var _initValues = {
    'title': '',
    'ingredients': '',
    'steps': '',
    'price': '',
    'time': '',
    'imageUrl': '',
  };

  var _isInit = true;
  var _isLoading = false;

  @override
  void initState() {
    _imageUrlFocusNode.addListener(_updateImageUrl);
    super.initState();
  }

  @override
  void didChangeDependencies() {
    if (_isInit) {
      final recipeId = ModalRoute.of(context).settings.arguments as String;
      if (recipeId != null) {
        _editedRecipe = Provider.of<Recipes>(context).findById(recipeId);
        _initValues = {
          'title': _editedRecipe.title,
          'ingredients': _editedRecipe.ingredients,
          'steps': _editedRecipe.steps,
          'price': _editedRecipe.price.toString(),
          'time': _editedRecipe.time.toString(),
          'imageUrl': '',
        };
        _imageUrlController.text = _editedRecipe.imageUrl;
      }
    }
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _imageUrlFocusNode.removeListener(_updateImageUrl);
    _priceFocusNode.dispose();
    _stepsFocusNode.dispose();
    _ingredientsFocusNode.dispose();
    _imageUrlController.dispose();
    _imageUrlFocusNode.dispose();
    super.dispose();
  }

  void _updateImageUrl() {
    if (!_imageUrlFocusNode.hasFocus) {
      if ((!_imageUrlController.text.startsWith('http') &&
              !_imageUrlController.text.startsWith('https')) ||
          (!_imageUrlController.text.endsWith('.png') &&
              !_imageUrlController.text.endsWith('.jpg') &&
              !_imageUrlController.text.endsWith('.jpeg'))) {
        return;
      }
      setState(() {});
    }
  }

  Future<void> _saveForm() async {
    final isValid = _form.currentState.validate();
    if (!isValid) {
      return;
    }
    _form.currentState.save();
    setState(() {
      _isLoading = true;
    });
    if (_editedRecipe.id != null) {
      await Provider.of<Recipes>(context, listen: false)
          .updateRecipe(_editedRecipe.id, _editedRecipe);
    } else {
      try {
        await Provider.of<Recipes>(context, listen: false)
            .addRecipe(_editedRecipe);
      } catch (error) {
        await showDialog<Null>(
          context: context,
          builder: (ctx) => AlertDialog(
            title: Text('An error occurred'),
            content: Text('Something went wrong'),
            actions: <Widget>[
              FlatButton(
                child: Text('Okay'),
                onPressed: () {
                  Navigator.of(ctx).pop();
                },
              ),
            ],
          ),
        );
      }
    }
    setState(() {
      _isLoading = false;
    });
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Edit Recipe',
        ),
        actions: <Widget>[
          IconButton(
            icon: Icon(
              Icons.save,
            ),
            onPressed: _saveForm,
          ),
        ],
      ),
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : Padding(
              padding: EdgeInsets.only(
                left: 20,
                right: 40,
                top: 20,
                bottom: 20,
              ),
              child: Form(
                key: _form,
                child: SingleChildScrollView(
                  child: Column(
                    children: <Widget>[
                      Container(
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: Theme.of(context).primaryColor,
                          ),
                          borderRadius: BorderRadius.circular(7),
                        ),
                        child: TextFormField(
                          initialValue: _initValues['title'],
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            focusedBorder: InputBorder.none,
                            contentPadding: EdgeInsets.only(
                                left: 15, bottom: 11, top: 11, right: 15),
                            labelText: 'Title',
                          ),
                          textInputAction: TextInputAction.next,
                          onFieldSubmitted: (_) {
                            FocusScope.of(context)
                                .requestFocus(_priceFocusNode);
                          },
                          validator: (value) {
                            if (value.isEmpty) {
                              return 'Please provide a value.';
                            }
                            return null;
                          },
                          onSaved: (value) {
                            _editedRecipe = Recipe(
                              id: _editedRecipe.id,
                              title: value,
                              ingredients: _editedRecipe.ingredients,
                              steps: _editedRecipe.steps,
                              price: _editedRecipe.price,
                              time: _editedRecipe.time,
                              imageUrl: _editedRecipe.imageUrl,
                              isFavourite: _editedRecipe.isFavourite,
                            );
                          },
                        ),
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      Container(
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: Theme.of(context).primaryColor,
                          ),
                          borderRadius: BorderRadius.circular(7),
                        ),
                        child: TextFormField(
                          initialValue: _initValues['price'],
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            focusedBorder: InputBorder.none,
                            contentPadding: EdgeInsets.only(
                                left: 15, bottom: 11, top: 11, right: 15),
                            labelText: 'Price',
                          ),
                          textInputAction: TextInputAction.next,
                          keyboardType: TextInputType.number,
                          focusNode: _priceFocusNode,
                          onFieldSubmitted: (_) {
                            FocusScope.of(context).requestFocus(_timeFocusNode);
                          },
                          validator: (value) {
                            if (value.isEmpty) {
                              return 'Please enter a price.';
                            }
                            if (double.tryParse(value) == null) {
                              return 'Please enter a valid number.';
                            }
                            if (double.parse(value) <= 0) {
                              return 'Please enter a number greater than zero.';
                            }
                            return null;
                          },
                          onSaved: (value) {
                            _editedRecipe = Recipe(
                              id: _editedRecipe.id,
                              title: _editedRecipe.title,
                              ingredients: _editedRecipe.ingredients,
                              steps: _editedRecipe.steps,
                              price: double.parse(value),
                              time: _editedRecipe.time,
                              imageUrl: _editedRecipe.imageUrl,
                              isFavourite: _editedRecipe.isFavourite,
                            );
                          },
                        ),
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      Container(
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: Theme.of(context).primaryColor,
                          ),
                          borderRadius: BorderRadius.circular(7),
                        ),
                        child: TextFormField(
                          initialValue: _initValues['time'],
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            focusedBorder: InputBorder.none,
                            contentPadding: EdgeInsets.only(
                                left: 15, bottom: 11, top: 11, right: 15),
                            labelText: 'Time',
                          ),
                          textInputAction: TextInputAction.next,
                          keyboardType: TextInputType.number,
                          focusNode: _timeFocusNode,
                          onFieldSubmitted: (_) {
                            FocusScope.of(context)
                                .requestFocus(_ingredientsFocusNode);
                          },
                          validator: (value) {
                            if (value.isEmpty) {
                              return 'Please enter a time.';
                            }
                            if (double.tryParse(value) == null) {
                              return 'Please enter a valid number.';
                            }
                            if (double.parse(value) <= 0) {
                              return 'Please enter a number greater than zero.';
                            }
                            return null;
                          },
                          onSaved: (value) {
                            _editedRecipe = Recipe(
                              id: _editedRecipe.id,
                              title: _editedRecipe.title,
                              ingredients: _editedRecipe.ingredients,
                              steps: _editedRecipe.steps,
                              price: _editedRecipe.price,
                              time: int.parse(value),
                              imageUrl: _editedRecipe.imageUrl,
                              isFavourite: _editedRecipe.isFavourite,
                            );
                          },
                        ),
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      SingleChildScrollView(
                        child: Container(
                          height: 200,
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: Theme.of(context).primaryColor,
                            ),
                            borderRadius: BorderRadius.circular(7),
                          ),
                          child: TextFormField(
                            textAlignVertical: TextAlignVertical.top,
                            textAlign: TextAlign.start,
                            initialValue: _initValues['ingredients'],
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              focusedBorder: InputBorder.none,
                              contentPadding: EdgeInsets.only(
                                  left: 15, bottom: 11, top: 11, right: 15),
                              labelText: 'Ingredients',
                            ),
                            maxLines: 100,
                            keyboardType: TextInputType.multiline,
                            focusNode: _ingredientsFocusNode,
                            onFieldSubmitted: (_) {
                              FocusScope.of(context)
                                  .requestFocus(_stepsFocusNode);
                            },
                            validator: (value) {
                              if (value.isEmpty) {
                                return 'Please enter a ingredients';
                              }
                              if (value.length < 10) {
                                return 'Should be atleast 10 characters long.';
                              }
                              return null;
                            },
                            onSaved: (value) {
                              _editedRecipe = Recipe(
                                id: _editedRecipe.id,
                                title: _editedRecipe.title,
                                ingredients: value,
                                steps: _editedRecipe.steps,
                                price: _editedRecipe.price,
                                time: _editedRecipe.time,
                                imageUrl: _editedRecipe.imageUrl,
                                isFavourite: _editedRecipe.isFavourite,
                              );
                            },
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      SingleChildScrollView(
                        child: Container(
                          decoration: BoxDecoration(
                            border: Border.all(
                                color: Theme.of(context).primaryColor),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          height: 200,
                          child: TextFormField(
                            textAlignVertical: TextAlignVertical.top,
                            textAlign: TextAlign.start,
                            initialValue: _initValues['steps'],
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              focusedBorder: InputBorder.none,
                              contentPadding: EdgeInsets.only(
                                  left: 15, bottom: 11, top: 11, right: 15),
                              labelText: 'Procedure',
                            ),
                            maxLines: 200,
                            keyboardType: TextInputType.multiline,
                            focusNode: _stepsFocusNode,
                            validator: (value) {
                              if (value.isEmpty) {
                                return 'Please enter a steps';
                              }
                              if (value.length < 10) {
                                return 'Should be atleast 10 characters long.';
                              }
                              return null;
                            },
                            onSaved: (value) {
                              _editedRecipe = Recipe(
                                id: _editedRecipe.id,
                                title: _editedRecipe.title,
                                ingredients: _editedRecipe.ingredients,
                                steps: value,
                                price: _editedRecipe.price,
                                time: _editedRecipe.time,
                                imageUrl: _editedRecipe.imageUrl,
                                isFavourite: _editedRecipe.isFavourite,
                              );
                            },
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: <Widget>[
                          Container(
                            width: 100,
                            height: 100,
                            margin: EdgeInsets.only(
                              top: 8,
                              right: 10,
                            ),
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: Theme.of(context).primaryColor,
                                width: 1,
                              ),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: _imageUrlController.text.isEmpty
                                ? Center(
                                    child: Text('Enter a URL'),
                                  )
                                : FittedBox(
                                    child: Image.network(
                                      _imageUrlController.text,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                          ),
                          Expanded(
                            child: Container(
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: Theme.of(context).primaryColor,
                                ),
                                borderRadius: BorderRadius.circular(7),
                              ),
                              child: TextFormField(
                                decoration: InputDecoration(
                                  border: InputBorder.none,
                                  focusedBorder: InputBorder.none,
                                  contentPadding: EdgeInsets.only(
                                      left: 15, bottom: 11, top: 11, right: 15),
                                  labelText: 'Image URL',
                                ),
                                keyboardType: TextInputType.url,
                                textInputAction: TextInputAction.done,
                                controller: _imageUrlController,
                                onFieldSubmitted: (_) {
                                  _saveForm();
                                },
                                validator: (value) {
                                  if (value.isEmpty) {
                                    return 'Please enter an image URL.';
                                  }
                                  if (!value.startsWith('http') &&
                                      !value.startsWith('https')) {
                                    return 'Please enter a valid URL.';
                                  }
                                  if (!value.endsWith('.png') &&
                                      !value.endsWith('.jpg') &&
                                      !value.endsWith('.jpeg')) {
                                    return 'Please enter a valid Image URL.';
                                  }
                                  return null;
                                },
                                onSaved: (value) {
                                  _editedRecipe = Recipe(
                                    id: _editedRecipe.id,
                                    title: _editedRecipe.title,
                                    ingredients: _editedRecipe.ingredients,
                                    steps: _editedRecipe.steps,
                                    price: _editedRecipe.price,
                                    time: _editedRecipe.time,
                                    imageUrl: value,
                                    isFavourite: _editedRecipe.isFavourite,
                                  );
                                },
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
    );
  }
}
