import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';


// custom_error_widget.dart

class CustomErrorWidget extends StatelessWidget {
  final FlutterErrorDetails? errorDetails;
  final String? errorMessage;

  const CustomErrorWidget({
    super.key,
    this.errorDetails,
    this.errorMessage,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFAFAFA),
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SvgPicture.asset(
                  'assets/images/sad_face.svg',
                  height: 42,
                  width: 42,
                ),
                const SizedBox(height: 8),
                Text(
                  "Something went wrong",
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w500,
                    color: Color(0xFF262626),
                  ),
                ),
<<<<<<< HEAD
                const SizedBox(height: 4),
                SizedBox(
                  child: Text(
                    errorMessage ??
                      SvgPicture.asset(
                        'assets/images/sad_face.svg',
                        height: 42,
                        width: 42,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        "Something went wrong",
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.w500,
                          color: Color(0xFF262626),
                        ),
                      ),
                      const SizedBox(height: 4),
                      SizedBox(
                        child: Text(
                          errorMessage ??
                            errorDetails?.exceptionAsString() ??
                            'We encountered an unexpected error while processing your request.',
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontSize: 16,
                            color: Color(0xFF525252), // neutral-600
                          ),
                        ),
                      ),
                      if (errorDetails?.stack != null)
                        Padding(
                          padding: const EdgeInsets.only(top: 12.0),
                          child: SingleChildScrollView(
                            scrollDirection: Axis.vertical,
                            child: Text(
                              errorDetails!.stack.toString(),
                              style: const TextStyle(fontSize: 10, color: Colors.red),
                              maxLines: 8,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ),
                      const SizedBox(height: 24),
                      ElevatedButton.icon(
                        onPressed: () {
                          bool canBeBack = Navigator.canPop(context);
                          if (canBeBack) {
                            Navigator.of(context).pop();
                          } else {
                            Navigator.pushNamed(context, '/');
                          }
                        },
                        icon: const Icon(Icons.arrow_back, size: 18, color: Colors.white),
                        label: const Text('Back'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        }
      }
        ),
