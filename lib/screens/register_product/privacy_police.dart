import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:heroicons/heroicons.dart';
import 'package:scc_web/helper/app_scale.dart';
import 'package:scc_web/helper/assisted_auto_route.dart';
import 'package:scc_web/helper/constant.dart';
import 'package:scc_web/theme/colors.dart';

class PrivacyPolicy extends StatelessWidget {
  const PrivacyPolicy({super.key});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: kIsWeb && !isWebMobile
          ? EdgeInsets.symmetric(
              horizontal: (context.deviceWidth() * 0.15),
              vertical: (context.deviceHeight() * 0.1),
            )
          : const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      backgroundColor: Colors.transparent,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      child: Container(
        decoration: BoxDecoration(
          color: sccWhite,
          borderRadius: BorderRadius.circular(16),
        ),
        padding: const EdgeInsets.only(top: 12),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Privacy & Police',
                    style: TextStyle(fontSize: context.scaleFont(24)),
                  ),
                  InkWell(
                    onTap: () {
                      context.closeDialog();
                    },
                    child: HeroIcon(
                      HeroIcons.xMark,
                      color: sccButtonPurple,
                      size: context.scaleFont(28),
                    ),
                  )
                ],
              ),
            ),
            const Divider(
              color: sccLightGrayDivider,
              height: 25,
              thickness: 2,
            ),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Text(
                      'Privacy Policy',
                      style: TextStyle(fontSize: context.scaleFont(24)),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 10, right: 10),
                      child: Text(
                        "We respect your privacy and are committed to protecting your personal information. This privacy policy outlines how we collect, use, and safeguard the information you provide to us.\n"
                        "Information Collection \n"
                        "We may collect personal information, such as your name and email address, when you voluntarily provide it to us through our website or app. \n"
                        "Information Usage \n"
                        "We use the collected information to personalize your experience, improve our services, and respond to your inquiries or requests. We do not share your personal information with third parties, except when required by law or with your explicit consent. \n"
                        "Data Security \n"
                        "We implement reasonable security measures to protect your personal information from unauthorized access, alteration, disclosure, or destruction. \n"
                        "Changes to the Privacy Policy \n"
                        "We reserve the right to modify this privacy policy at any time. Any changes will be reflected on this page, and we encourage you to review it periodically. \n"
                        "Your Consent \n"
                        "By using our website or app, you consent to the terms of this privacy policy. \n"
                        "Contact Us \n"
                        "If you have any questions or concerns about our privacy policy, please contact us at [email address]. \n"
                        "This short privacy policy is a general template and may need customization to align with your specific circumstances and legal requirements. It's always recommended to consult with a legal professional to ensure compliance with applicable laws and regulations. \n",
                        style: TextStyle(fontSize: context.scaleFont(16)),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
