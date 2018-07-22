# Upstream packaging

The AppImage ecosystem is built around the notion of "upstream packaging". With AppImage, typically the application author is who packages and distributes the application. This is different from the traditional Linux distribution model, where the application author and the application packager (also called the maintainer) are often different persons.
AppimageKit is designed with “upstream packaging” in mind. This means that we want the original author of an application to be the person that packages it as an AppImage, distributes it to end users, and supports it.

In this regard, if image is very similar to an `.exe` file on Windows or a `.dmg` file on the Mac. These files are normally prepared by the original application authors rather than by third parties. This ensures that the software works exactly the way the original application author has envisioned it to work. It also means that the application author does not have to follow arbitrary rules set by Linux distributions.

So before your package an application as an AppImage, ask yourself whether you are either the application author or a member of the application team. If not, it is most likely better to ask the original author of the application or the application team to provide an official AppImage.

## Advantages

Upstream packaging has a lot of advantages:  first and foremost, it allows the application author to control the entire user experience from how the user gets the application to how it works. it also allows the original author of an application to support the application since no unauthorised changes or made to it by third parties. For end-users, it is clear that the original application author is who is responsible for fixing bugs come out as there is no shared responsibility between the application author and the third party, e.g. a Linux distribution, that has distributed the application.

## Disadvantages

However, upstream packaging also has disadvantages:  most prominently, there is no curator who assesses the quality and integrity of the application. Hence, the end user has to trust the application author when running an application that has been distributed directly by the original application author.
