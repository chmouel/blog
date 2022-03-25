---
title: Use cases for Docker driven development.
author: chmouel
type: post
date: 2014-11-10T20:58:01+00:00
url: /2014/11/10/use-cases-for-docker-driven-development/
dsq_thread_id:
  - 3211771872
tags:
  - Docker
  - Openstack

---
So the trend these days is to talk about container all the things that usually involve Docker, it even has a now its own verb, people are now using the word 'containerizing' to describe packaging their application with Docker.

A lot of the things happening lately in the Docker world is to solve how to get those containers in real [production environments,][1] there is people working on taking the 'containerization' philosophy to [storage,][2] [networking][3] or getting [orchestration][4] right

While getting docker in production is an important thing to have that would be hopefully getting solved and stable sometime soon, there is the use case for docker that can be used as of right now which is the developer use case.

I briefly mentioned this in another blog post and wanted to expand my thoughts here after chatting with some of my colleagues that don't seem to get how that would help and consider the docker trending not much more than a marketing trend.

> Take functional Testing to an another level.

[<img loading="lazy" class="alignright wp-image-849 " src="/wp-content/uploads/2014/11/cooking-woman2.jpg" alt="" width="171" height="270" srcset="https://blog.chmouel.com/wp-content/uploads/2014/11/cooking-woman2.jpg 551w, https://blog.chmouel.com/wp-content/uploads/2014/11/cooking-woman2-189x300.jpg 189w" sizes="(max-width: 171px) 100vw, 171px" />][5]

I am not going to go over of what functional testing is and all the different type of [Software testing][6]. There is a lot of them that are very well documented andexcept the unittests they usually need to have the real services properly up and running first

The testing driven development for unittests is a very well known process to develop application, it usually tightens to unittest. You start to write your unittests and write your code and fix your code/tests in an iterative way.

When the code is working usually it gets committed to a CI environment which run the unittests and maybe some other functional tests before it gets reviewed and merged.

The functional tests for that feature doesn't get committed at the same time, because usually running functional tests is painful and can takes a lot of time. You have to setup all the things properly, the initial setup of your DB and how it communicate to your service in the right context of how you want to do your testing.

And even if you go by that path and get it done, most people would just do it in a single VM easy to share among your colleagues and you wont' go by the process of properly setup bunch of vm that communicate together like a DB a APP and perhaps a WEB server. You won't even try to test how your application scales and behave cause that's even more costly.

> Have your functional testing done by multiple services not just a single VM.

And that's where testing with docker with an orchestrator like [fig][7] can shine. You can specify different scenarios that are really quick to deploy. You can run different runs and targets directly from your CI and more importantly  
you can easily share those to your colleagues/contributors and that's usually very fast cause if there is one thing docker is good is that it does a lot of smart caching to build the images and run those images in a blink of a second.

> Show your users how your app should be deploy.

[<img loading="lazy" class="alignleft wp-image-853 size-thumbnail" src="/wp-content/uploads/2014/11/team_building_with_cooking-150x150.jpg" alt="team_building_with_cooking" width="150" height="150" srcset="https://blog.chmouel.com/wp-content/uploads/2014/11/team_building_with_cooking-150x150.jpg 150w, https://blog.chmouel.com/wp-content/uploads/2014/11/team_building_with_cooking-144x144.jpg 144w" sizes="(max-width: 150px) 100vw, 150px" />][8]When you build your Dockerfiles you show the way how your apps is building and how the configuration is setup. You are able to give ideas to your users how it would work. It may not going to be optimal and perfect since you probably not going to have the same experience and tweaking of someone who deploys complicated software for a living but at least you can give a guideline how things works without having the user pulling his hair how things works.

> Even your unittesting can get more robust!

This is to follow up on my blog post on the tool [dox][9] I have introduced, since in OpenStack we have some very complicated tests to do that are very much dependent of a system it gets very complicated to run our unittests in a portable. But that's not just OpenStack take for example an app that needs Sqlalchemy to run, you can sure run it with sqlite backend to run your unittests but you may going to end up in weird cases with your foreign keys not working properly and other SQL features not implemented. With containers you can have a container that gets setup with your DB of your choice to do your testing against easily. There is more use cases where you depend of the binary (or your dependences) depend of the system that you want to be controlled and contained.

I hope those points would help you to get convinced into containers in your development workflow. Hopefully in the future all those workflow would generalised more and we would have even more powerful tools to get our development (almost) perfectly done â„¢

[<img loading="lazy" class="aligncenter wp-image-852 size-medium" src="/wp-content/uploads/2014/11/spicy_meatball-300x295.jpg" alt="spicy_meatball" width="300" height="295" srcset="https://blog.chmouel.com/wp-content/uploads/2014/11/spicy_meatball-300x295.jpg 300w, https://blog.chmouel.com/wp-content/uploads/2014/11/spicy_meatball.jpg 512w" sizes="(max-width: 300px) 100vw, 300px" />][10]

 [1]: http://www.projectatomic.io/
 [2]: https://clusterhq.com/
 [3]: https://github.com/zettio/weave
 [4]: https://github.com/GoogleCloudPlatform/kubernetes
 [5]: /wp-content/uploads/2014/11/cooking-woman2.jpg
 [6]: http://en.wikipedia.org/wiki/Software_testing
 [7]: http://fig.sh
 [8]: /wp-content/uploads/2014/11/team_building_with_cooking.jpg
 [9]: https://blog.chmouel.com/2014/09/08/dox-a-tool-that-run-python-or-others-tests-in-a-docker-container/
 [10]: /wp-content/uploads/2014/11/spicy_meatball.jpg