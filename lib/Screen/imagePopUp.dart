import 'dart:async';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';

class ImagePopUp extends StatefulWidget {
  final List<String?> attachmentUrls;
  final int index;

  const ImagePopUp(
      {Key? key, required this.attachmentUrls, required this.index})
      : super(key: key);

  @override
  State<ImagePopUp> createState() => ImagePopUpState();
}

class ImagePopUpState extends State<ImagePopUp>
    with SingleTickerProviderStateMixin {
  AnimationController? controller;
  Animation<double>? scaleAnimation;

  ValueNotifier<int> isCurrentIndex = ValueNotifier<int>(0);
  late PageController pageController = PageController(initialPage: 0);

  final ValueNotifier<bool> isSelectedSharefeed = ValueNotifier<bool>(false);
  ValueNotifier<List<int>> selectedShareIndices = ValueNotifier<List<int>>([]);
  ValueNotifier<int> currentPage = ValueNotifier<int>(1);

  StreamController<int> valueController = StreamController<int>.broadcast();
  final ValueNotifier<bool> isSelectedfeed = ValueNotifier<bool>(false);
  ValueNotifier<List<int>> selectedIndices = ValueNotifier<List<int>>([]);

  late List<PhotoViewController> photoControllers;
  late List<PhotoViewScaleStateController> scaleStateControllers;
  /*----------------------------------------------------------------------------------------------*/
  /*--------------------------------------------Init State----------------------------------------*/
  /*----------------------------------------------------------------------------------------------*/
  @override
  void initState() {
    super.initState();
    photoControllers = List.generate(
        widget.attachmentUrls.length, (_) => PhotoViewController());
    scaleStateControllers = List.generate(
        widget.attachmentUrls.length, (_) => PhotoViewScaleStateController());
    controller =
        AnimationController(vsync: this, duration: Duration(milliseconds: 550));
    scaleAnimation =
        CurvedAnimation(parent: controller!, curve: Curves.elasticInOut);

    controller!.forward();
    pageController = PageController(initialPage: widget.index);
    pageController.addListener(_pageChangeListener);

    isCurrentIndex.value = widget.index;
    currentPage.value = widget.index;
    valueController.sink.add(currentPage.value);
  }

  /*----------------------------------------------------------------------------------------------*/
  /*---------------------------------------------Dispose -----------------------------------------*/
  /*----------------------------------------------------------------------------------------------*/
// Dispose the PageController when the widget is disposed
  @override
  void dispose() {
    controller!.dispose();
    valueController.close();
    pageController.removeListener(_pageChangeListener);
    pageController.dispose();

    super.dispose();
  }

  /*----------------------------------------------------------------------------------------------*/
  /*-----------------------------------Page change Listener---------------------------------------*/
  /*----------------------------------------------------------------------------------------------*/

  void _pageChangeListener() {
    //updating the pagecontroller value on swaping or navigating
    isCurrentIndex.value = pageController.page!.toInt();
    isCurrentIndex.notifyListeners();
    // currentPage.value =  pageController.page!.toInt();
    ///currentPage.notifyListeners();
  }

  @override
  Widget build(BuildContext context) {
    return body();
  }

  /*----------------------------------------------------------------------------------------------*/
  /*------------------------------------------Build Body------------------------------------------*/
  /*----------------------------------------------------------------------------------------------*/
  Widget body() {
    return GestureDetector(
      onTap: () {
        // to go back when user tap on outside area of preview
        Navigator.pop(context);
      },
      child: Container(
        child: Stack(children: [
          OrientationBuilder(builder: (context, orientation) {
            return Container(
                color: Colors.transparent,
                padding: EdgeInsets.only(
                    top: MediaQuery.of(context).size.height * 0.12,
                    bottom: MediaQuery.of(context).size.height * 0.024),
                constraints: BoxConstraints(
                    minHeight: MediaQuery.of(context).size.height * 0.8),
                child: Stack(children: [
                  Padding(
                    padding: EdgeInsets.only(bottom: 65.0),
                    child: buildSlider(
                        currentPage: currentPage, orientation: orientation),
                  ),
                  _buildPreviousButton(),
                  _buildNextButton(),
                ]));
          }),
          ValueListenableBuilder(
              valueListenable: currentPage,
              builder: (context, value, child) {
                return StreamBuilder(
                    stream: valueController.stream,
                    builder: (context, snapshot) {
                      return previewHeader();
                    });
              })
        ]),
      ),
    );
  }

  Widget previewHeader() {
    return Positioned(
      // left: 10,
      top: 30.0,
      right: 10.0,
      child: Column(
        children: [
          Container(
              height: 40,
              width: 40,
              decoration: BoxDecoration(
                  color: Colors.grey.withOpacity(0.3), shape: BoxShape.circle),
              child: IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: FittedBox(
                      fit: BoxFit.fitHeight,
                      child: Icon(Icons.clear,
                          color: Theme.of(context).primaryColor, size: 30)))),
          SizedBox(
            height: 5,
          ),
          Row(
            children: [
              Text(
                "${currentPage.value + 1}/",
                style: TextStyle(),
              ),
              Text(
                "${widget.attachmentUrls.length}",
                style: TextStyle(color: Colors.grey),
              ),
            ],
          )
        ],
      ),
    );
  }

  String extractPreviewTitle(String str) {
    // Find the last occurrence of '_'
    int lastUnderscoreIndex = str.indexOf('_'); //str.lastIndexOf('_');

    // If there is no underscore, return the whole string
    if (lastUnderscoreIndex == -1) {
      return Uri.decodeComponent(str);
    }

    // Extract substring from the last underscore to the end
    String result = str.substring(lastUnderscoreIndex + 1);

    // Find the position of the first '%'
    int percentIndex = result.indexOf('%');

    // If '%' is found, truncate the string at that point
    if (percentIndex != -1) {
      result = result.substring(0, percentIndex);
    }

    // Decode the URL encoded string
    return Uri.decodeComponent(result);
  }

  /*----------------------------------------------------------------------------------------------*/
  /*---------------------------------Build View Slider------------------------------------------*/
  /*----------------------------------------------------------------------------------------------*/
  Widget buildSlider(
      {required Orientation orientation,
      required ValueNotifier<int> currentPage}) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      child: GestureDetector(
        onTap: () {
          //to not to go back while taping on image area
        },
        child: PageView.builder(
          controller: pageController, // PageController(),
          itemCount: widget.attachmentUrls.length,
          onPageChanged: (index) {
            currentPage.value = index;

            //     currentPage.notifyListeners();
            valueController.sink.add(currentPage.value);
            isSelectedfeed.value =
                selectedIndices.value.contains(currentPage.value);
            isSelectedSharefeed.value =
                selectedShareIndices.value.contains(currentPage.value);
          },
          itemBuilder: (context, index) {
            return imagePreviewWidget(
                attachmentUrl: widget.attachmentUrls[index], index: index);
          },
        ),
      ),
    );
  }

//----------------------------------image preview------------------------------------
  Widget imagePreviewWidget({required attachmentUrl, required int index}) {
    return PhotoView(
      backgroundDecoration: BoxDecoration(color: Colors.transparent),
      imageProvider: CachedNetworkImageProvider(attachmentUrl),
      controller: photoControllers[index],
      scaleStateController: scaleStateControllers[index],
      loadingBuilder: (context, event) => Center(
        child: CircularProgressIndicator(),
      ),
      errorBuilder: (context, url, error) =>
          Container(color: Colors.white, child: Text('Unable to load image')),
    );
  }

  /*----------------------------------------------------------------------------------------------*/
  /*------------------------------------Build Previous Button-------------------------------------*/
  /*----------------------------------------------------------------------------------------------*/
  Widget _buildPreviousButton() {
    return ValueListenableBuilder(
        valueListenable: currentPage,
        builder: (context, value, child) {
          return Align(
              alignment: Alignment.centerLeft,
              child: Padding(
                  padding: EdgeInsets.only(
                      left: MediaQuery.of(context).size.width * 0.015,
                      bottom: MediaQuery.of(context).size.height * 0.08),
                  child: Container(
                    height: 28,
                    width: 28,
                    decoration: BoxDecoration(
                        color: currentPage.value == 0
                            ? Colors.transparent
                            : Colors.grey.withOpacity(0.7),
                        shape: BoxShape.circle),
                    child: Center(
                      child: Padding(
                        padding: const EdgeInsets.only(left: 7),
                        child: GestureDetector(
                          onTap: () {
                            if (currentPage.value > 0) {
                              currentPage.value--;
                              pageController.previousPage(
                                  duration: Duration(milliseconds: 300),
                                  curve: Curves.ease);
                            }
                          },
                          child: currentPage.value == 0
                              ? SizedBox.shrink()
                              : Icon(Icons.arrow_back_ios,
                                  size: 20,
                                  color: Theme.of(context).primaryColor),
                        ),
                      ),
                    ),
                  )));
        });
  }

  /*----------------------------------------------------------------------------------------------*/
  /*----------------------------------------Build Next Button-------------------------------------*/
  /*----------------------------------------------------------------------------------------------*/
  Widget _buildNextButton() {
    return ValueListenableBuilder(
        valueListenable: currentPage,
        builder: (context, value, child) {
          return Align(
              alignment: Alignment.centerRight,
              child: Padding(
                  padding: EdgeInsets.only(
                      right: MediaQuery.of(context).size.width * 0.016,
                      bottom: MediaQuery.of(context).size.height * 0.08),
                  child: currentPage.value != widget.attachmentUrls.length - 1
                      ? Container(
                          height: 28,
                          width: 28,
                          decoration: BoxDecoration(
                              color: Colors.grey.withOpacity(0.7),
                              shape: BoxShape.circle),
                          child: Padding(
                              padding: const EdgeInsets.only(left: 5),
                              child: Center(
                                child: GestureDetector(
                                  onTap: () {
                                    if (currentPage.value <
                                        widget.attachmentUrls.length - 1) {
                                      currentPage.value++;
                                      pageController.nextPage(
                                          duration: Duration(milliseconds: 300),
                                          curve: Curves.ease);
                                    }
                                  },
                                  child: Icon(Icons.arrow_forward_ios,
                                      size: 20,
                                      color: Theme.of(context).primaryColor),
                                ),
                              )),
                        )
                      : SizedBox.shrink()));
        });
  }

// this will close the attachment Widget popup will trigger from notifications tap
}
