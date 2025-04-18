import 'package:crud_app/ui/typography/text_heading.dart';
import 'package:flutter/material.dart';

class GuideView extends StatelessWidget {
  const GuideView({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextHeading(
              text: 'Introduction',
              style: TextStyle(
                  fontSize: 24
              ),
            ),
            SizedBox(height: 20),
            Text(
                r"""Hello, new user, and welcome to the SCP Wiki! I'm sure you already had a lot of questions before you even clicked on this guide: "What is this site about?", "Where do I start reading?", "How do I write an SCP?", "How do you pronounce Keter?", "What is Keter?"… """
            ),
            SizedBox(height: 15),
            Text(
              r"""To spare you all the trouble of having to navigate blindly through over ten thousand pages of content, this introduction aims to answer as many of these questions as we can, hopefully without taking too much time."""
            ),

            SizedBox(height: 20),

            Text(
              "What is this Place about?",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold
              ),
            ),
            SizedBox(height: 15),
            Text(
              r"""This is the SCP Foundation Wiki, a collaborative writing site based around the premise that… in essence, magic is real. It's not exactly like the traditional fantasy style magic you've come to know, but that's the best way we can describe the stuff we have here - Anomalies; items and critters that do not follow the rules of nature as we know them. Staircases that go on forever, mechanical gods from the beginning of time, otherwise regular humans who reshape reality with their mind: these are the kinds of things that, if known to the public, could cause mass hysteria and start wars on scales unprecedented. Due to that, there exists an organization called the SCP Foundation, whose job is to research paranormal activity, keep these creatures and objects concealed from the public, and protect humanity from the horrors of the dark."""
            ),
            SizedBox(height: 15),
            Text(
              r"""That's the long and short of it - this site is a place where a bunch of different people write stories about an organization that keeps the inexplicable under lock and key, except instead of just calling it "magic" we use science-y terms like "ontokinesis" or "thaumatology." The wiki started as a horror/creepypasta site so the majority of the older content is focused around that, but since then we've expanded our horizons and nowadays you can find any type of writing you'd want, from novella-length adventures to one-line jokes."""
            ),

            SizedBox(height: 20),

            Text(
              "Why is Everything Contradictory?",
              style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold
              ),
            ),
            SizedBox(height: 15),
            Text(
              r"""To reach over ten thousand articles onsite, we had to let go of the idea of a singular "canon", meaning that every article on the site is allowed to contradict and disregard any other article, no matter how well known or popular. Did someone say the Foundation was formed in the 1960s, but you need the Foundation to exist in WWI? The Foundation is now from the 19th century, sure. You want a Foundation that has more resources than the eye can see? Go wild. You want a Foundation that's penniless? Why not! As long as the story is interesting, your freedom is basically unlimited."""
            ),
            SizedBox(height: 15),
            Text(
              r"""While this is often phrased as "there is no canon", this doesn't mean that nothing on the site can coexist - many articles can share the same universe, and some explicitly reference each other. It just means that you don't have to try to fit everything into a singular version of the Foundation."""
            ),

          ],
        ),
      )
    );
  }
}