import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/products_provider.dart';
import '../models/product.dart';

class EditProductScreen extends StatefulWidget {
  static const routeName = '/edit-products';
  @override
  _EditProductScreenState createState() => _EditProductScreenState();
}

class _EditProductScreenState extends State<EditProductScreen> {

  final _priceFocusNode =FocusNode();
  final _descFocusNode =FocusNode();
  final _imageUrlController = new TextEditingController();
  final _imgUrlFocusNode = FocusNode();
  final _form = GlobalKey<FormState>();

  var  _editProduct = Product(
    id: null,
    title: '',
    price: 0.0,
    desc: '',
    imgUrl: '',
  );
  var _isInit = true;
  var _initValues = {
    'title' : '',
    'description' : '',
    'price' : '',
    'imageUrl' : '',
  };
  var _isLoading = false;

  @override
  void dispose() {
    // TODO: implement dispose
    _imgUrlFocusNode.removeListener(_updateImageUrl);
    _priceFocusNode.dispose();
    _descFocusNode.dispose();
    _imageUrlController.dispose();
    _imgUrlFocusNode.dispose();
    super.dispose();
  }

  @override
  void initState() {
    // TODO: implement initState
    _imgUrlFocusNode.addListener(_updateImageUrl);
    super.initState();
  }

  @override
  void didChangeDependencies() {
    if(_isInit)
    {

      final productId = ModalRoute.of(context).settings.arguments as String;
      if(productId != null)
      {
        _editProduct = Provider.of<ProductProvider>(context, listen: false ).findById(productId);
        _initValues = {
          'title' : _editProduct.title,
          'description' : _editProduct.desc,
          'price' : _editProduct.price.toString(),
//          'imageUrl' : _editProduct.imgUrl,
        };
        _imageUrlController.text= _editProduct.imgUrl;

      }

    }
    _isInit=false;
    super.didChangeDependencies();
  }

  void _updateImageUrl()
  {
    if(!_imgUrlFocusNode.hasFocus)
    {
      setState(() {

      });
    }

  }

  Future<void> _saveForm() async
  {
    final isValid = _form.currentState.validate();
    if(!isValid)
    {
      return;
    }
    _form.currentState.save();

    setState(() {
      _isLoading = true;
    });
    if(_editProduct.id != null)
    {
      await Provider.of<ProductProvider>(context, listen: false).updateProduct(_editProduct.id , _editProduct);

    } else
    {

      try{
        await Provider.of<ProductProvider>(context, listen: false).addProduct(_editProduct);
      } catch (error)
      {
        await showDialog(
            context: context,
            builder: (ctx) => AlertDialog(
              title: Text('An error occured'),
              content: Text('Something went wrong'),
              actions: <Widget>[
                FlatButton(
                  child: Text('Okay'),
                  onPressed: ()
                  {
                    Navigator.of(ctx).pop();

                  },
                )
              ],
            )
        );

      }
  //      finally{
  //
  //        setState(() {
  //          _isLoading = false;
  //        });
  //      }
    }
    setState(() {
      _isLoading = false;
    });
    Navigator.of(context).pop();


    //Navigator.of(context).pop();

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Product'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.save),
            onPressed: (){
              _saveForm();
            },
          )
        ],
      ),
      body: _isLoading?
      Center(
        child:CircularProgressIndicator(),
      ):
      Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _form,
          child: ListView(
            children: <Widget>[
              TextFormField(
                initialValue: _initValues['title'],
                decoration: InputDecoration(labelText: 'Title'),
                textInputAction: TextInputAction.next,
                onFieldSubmitted: (_)
                {
                  FocusScope.of(context).requestFocus(_priceFocusNode);
                },
                validator: (value)
                {
                  if(value.isEmpty)
                  {
                    return ('Please provide a value');
                  } else
                  {
                    return null;
                  }
                },
                onSaved: (value)
                {
                  _editProduct = Product(
                    title: value,
                    price: _editProduct.price,
                    desc: _editProduct.desc,
                    imgUrl: _editProduct.imgUrl,
                    id: _editProduct.id,
                    isFavourite: _editProduct.isFavourite,
                  );
                },
              ),
              TextFormField(
                initialValue: _initValues['price'],
                decoration: InputDecoration(labelText: 'Price'),
                textInputAction: TextInputAction.next,
                keyboardType: TextInputType.number,
                focusNode: _priceFocusNode,
                onFieldSubmitted: (_)
                {
                  FocusScope.of(context).requestFocus(_descFocusNode);
                },
                validator: (value)
                {
                  if(value.isEmpty)
                  {
                    return ('Please provide a value');

                  }else if(double.tryParse(value)==null){

                    return ('Please enter a valid number');
                  }else if(double.parse(value)<=0.0)
                  {
                    return ('Please enter a valid number');
                  } else
                  {
                    return (null);
                  }
                },
                onSaved: (value)
                {
                  _editProduct = Product(
                    title: _editProduct.title,
                    price: double.parse(value),
                    desc: _editProduct.desc,
                    imgUrl: _editProduct.imgUrl,
                    id: _editProduct.id,
                    isFavourite: _editProduct.isFavourite,
                  );
                },
              ),

              TextFormField(
                initialValue: _initValues['description'],
                decoration: InputDecoration(labelText: 'Description'),
                maxLines: 3,
                keyboardType: TextInputType.multiline,
                focusNode: _descFocusNode,
                validator: (value)
                {
                  if(value.isEmpty)
                  {
                    return ('Please provide a description');
                  } else if(value.length<=10)
                  {
                    return ('Description should be more than 10 characters');
                  } else
                  {
                    return (null);
                  }
                },
                onSaved: (value)
                {
                  _editProduct = Product(
                    title: _editProduct.title,
                    price:_editProduct.price,
                    desc: value,
                    imgUrl: _editProduct.imgUrl,
                    id: _editProduct.id,
                    isFavourite: _editProduct.isFavourite,
                  );
                },
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: <Widget>[
                  Expanded(
                    child: Container(
                      height: 100,
                      width: 100,
                      margin: EdgeInsets.only(top: 8, right: 10, ),
                      decoration: BoxDecoration(
                        border: Border.all(
                            width: 1,
                            color: Colors.greenAccent
                        ),
                      ),
                      child: _imageUrlController.text.isEmpty ?
                      Text('Enter a URL') : FittedBox(
                        child: Image.network(_imageUrlController.text),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  Expanded(
                    child: TextFormField(
                      decoration: InputDecoration(
                        labelText: 'image URL',
                      ),
                      keyboardType: TextInputType.url,
                      textInputAction: TextInputAction.done,
                      controller: _imageUrlController,
                      focusNode: _imgUrlFocusNode,
                      validator: (value)
                      {
                        if(value.isEmpty)
                        {
                          return ('Please provide a imageUrl');
                        } else if(!value.startsWith('http') && !value.startsWith('https'))
                        {
                          return ('Please provide a valid URL');
                        }
                        else
                        {
                          return (null);
                        }
                      },
                      onFieldSubmitted: (_)
                      {
                        _saveForm();
                      },
                      onSaved: (value)
                      {
                        _editProduct = Product(
                          title: _editProduct.title,
                          price: _editProduct.price,
                          desc: _editProduct.desc,
                          imgUrl: value,
                          id: _editProduct.id,
                          isFavourite: _editProduct.isFavourite,
                        );
                      },
                    ),
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
