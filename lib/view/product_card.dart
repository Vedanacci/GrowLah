import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:grow_lah/model/system_data.dart';
import 'package:grow_lah/utils/app_config.dart';
import 'package:grow_lah/view/product_list.dart';
import 'product_page.dart';

class ProductCard extends StatelessWidget {
  const ProductCard(
      {Key key,
      this.width = 140,
      this.aspectRetio = 1.02,
      @required this.indexIn,
      @required this.product,
      this.padding})
      : super(key: key);

  final double width, aspectRetio;
  final SystemData product;
  final int indexIn;
  final EdgeInsetsGeometry padding;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding == null
          ? EdgeInsets.only(left: getProportionateScreenWidth(20))
          : padding,
      child: SizedBox(
        width: getProportionateScreenWidth(width),
        height: getProportionateScreenWidth(width) * 1.02 +
            getProportionateScreenWidth(28) +
            22,
        child: GestureDetector(
          onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => ProductPage(
                        indexIn: indexIn,
                      ))),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AspectRatio(
                aspectRatio: 1.02,
                child: Neumorphic(
                    style: AppConfig.neuStyle.copyWith(
                        shadowLightColor: Colors.transparent,
                        color: Colors.transparent,
                        boxShape: NeumorphicBoxShape.roundRect(
                            BorderRadius.circular(15))),
                    child: Container(
                      padding: EdgeInsets.all(getProportionateScreenWidth(20)),
                      decoration: BoxDecoration(
                        color: Colors.green,
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Hero(
                        tag: product.name,
                        child: Image.asset("images/onboarding1.png"),
                      ),
                    )),
              ),
              const SizedBox(height: 10),
              Text(
                product.name,
                style: TextStyle(color: Colors.black),
                maxLines: 2,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "\$${product.price}",
                    style: TextStyle(
                      fontSize: getProportionateScreenWidth(18),
                      fontWeight: FontWeight.w600,
                      color: Colors.green,
                    ),
                  ),
                  InkWell(
                    borderRadius: BorderRadius.circular(50),
                    onTap: () {},
                    child: Container(
                      padding: EdgeInsets.all(getProportionateScreenWidth(8)),
                      height: getProportionateScreenWidth(28),
                      width: getProportionateScreenWidth(28),
                      decoration: BoxDecoration(
                        color: Colors.green,
                        shape: BoxShape.circle,
                      ),
                      child: Container(
                        alignment: Alignment.center,
                        padding: EdgeInsets.all(0),
                        decoration: BoxDecoration(
                          color: Colors.green,
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.favorite,
                          color: Colors.white,
                          size: 12,
                        ),
                      ),
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}

class HorizontalProductCard extends StatelessWidget {
  const HorizontalProductCard(
      {Key key,
      this.width = 140,
      this.aspectRetio = 1.02,
      @required this.indexIn,
      @required this.product,
      this.padding = EdgeInsets.zero})
      : super(key: key);

  final double width, aspectRetio;
  final SystemData product;
  final int indexIn;
  final EdgeInsetsGeometry padding;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding,
      child: SizedBox(
        width: SizeConfig.screenWidth,
        height: (SizeConfig.screenWidth) / 4,
        child: GestureDetector(
          onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => ProductPage(
                        indexIn: indexIn,
                      ))),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              AspectRatio(
                aspectRatio: 1.02,
                child: Neumorphic(
                    style: AppConfig.neuStyle.copyWith(
                        shadowLightColor: Colors.transparent,
                        color: Colors.transparent,
                        boxShape: NeumorphicBoxShape.roundRect(
                            BorderRadius.circular(15))),
                    child: Container(
                      padding: EdgeInsets.all(getProportionateScreenWidth(20)),
                      decoration: BoxDecoration(
                        color: Colors.green,
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Hero(
                        tag: product.name,
                        child: Image.asset("images/onboarding1.png"),
                      ),
                    )),
              ),
              const SizedBox(width: 20),
              Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      product.name,
                      style: TextStyle(color: Colors.white),
                      maxLines: 2,
                    ),
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "\$${product.price}",
                          style: TextStyle(
                            fontSize: getProportionateScreenWidth(18),
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                        Text(" x " + product.quantity.toString(),
                            style: TextStyle(
                              fontSize: getProportionateScreenWidth(12),
                              fontWeight: FontWeight.w300,
                              color: Colors.white,
                            ))
                      ],
                    )
                  ])
            ],
          ),
        ),
      ),
    );
  }
}

class ProductSwipe extends StatelessWidget {
  const ProductSwipe({
    Key key,
    @required this.systemData,
  }) : super(key: key);

  final List<SystemData> systemData;
  @override
  Widget build(BuildContext context) {
    List<Widget> products = [];
    for (SystemData data in systemData) {
      products.add(ProductCard(
        product: data,
        indexIn: systemData.indexOf(data),
      ));
    }
    products.add(Padding(
        padding: EdgeInsets.only(right: getProportionateScreenWidth(20))));
    return Neumorphic(
        style: AppConfig.neuStyle.copyWith(
            shadowLightColor: Colors.transparent,
            shadowDarkColor: Colors.transparent,
            lightSource: LightSource.bottom,
            color: Colors.transparent,
            boxShape: NeumorphicBoxShape.roundRect(BorderRadius.only(
                topLeft: Radius.circular(20), topRight: Radius.circular(20)))),
        child: Container(
          decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20), topRight: Radius.circular(20)),
              color: Colors.grey.shade300),
          child: Column(
            children: [
              SizedBox(height: getProportionateScreenWidth(20)),
              Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: getProportionateScreenWidth(20)),
                child: SectionTitle(
                    title: "Suggested Products",
                    press: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => ProductList()));
                    }),
              ),
              SizedBox(height: getProportionateScreenWidth(20)),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: products,
                ),
              ),
              SizedBox(height: getProportionateScreenWidth(30)),
            ],
          ),
        ));
  }
}

class ProductGrid extends StatelessWidget {
  const ProductGrid({
    Key key,
    @required this.systemData,
  }) : super(key: key);

  final List<SystemData> systemData;
  @override
  Widget build(BuildContext context) {
    List<Widget> products = [];
    for (SystemData data in systemData) {
      products.add(ProductCard(
        product: data,
        indexIn: systemData.indexOf(data),
        padding: EdgeInsets.all(10),
      ));
    }
    return Neumorphic(
        style: AppConfig.neuStyle.copyWith(
            shadowLightColor: Colors.transparent,
            shadowDarkColor: Colors.transparent,
            lightSource: LightSource.bottom,
            color: Colors.transparent,
            boxShape: NeumorphicBoxShape.roundRect(BorderRadius.only(
                topLeft: Radius.circular(20), topRight: Radius.circular(20)))),
        child: Container(
          constraints: BoxConstraints(minHeight: SizeConfig.screenHeight),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20), topRight: Radius.circular(20)),
              color: Colors.white),
          child: Column(
            children: [
              SizedBox(height: getProportionateScreenWidth(20)),
              Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: getProportionateScreenWidth(20)),
                child: SectionTitle(
                    title: "Products",
                    press: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => ProductList()));
                    }),
              ),
              SizedBox(height: getProportionateScreenWidth(20)),
              Wrap(
                children: products,
                spacing: 10,
                runSpacing: 10,
                crossAxisAlignment: WrapCrossAlignment.end,
                alignment: WrapAlignment.center,
                runAlignment: WrapAlignment.end,
              ),
              SizedBox(height: getProportionateScreenWidth(30)),
            ],
          ),
        ));
  }
}

class SectionTitle extends StatelessWidget {
  const SectionTitle({
    Key key,
    @required this.title,
    @required this.press,
  }) : super(key: key);

  final String title;
  final GestureTapCallback press;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Text(
          title,
          style: Theme.of(context).textTheme.headline5.copyWith(
              fontWeight: FontWeight.bold,
              fontSize: getProportionateScreenWidth(22)),
        ),
        GestureDetector(
          onTap: press,
          child: Text(
            "See More",
            style: TextStyle(color: Colors.black),
          ),
        ),
      ],
    );
  }
}
