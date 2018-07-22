# Upstream packaging

Please note that with that AppImage, typically the application author is who packages the application. This is different from the traditional Linux distribution model, where the application author and the application packager (also called the maintainer) are often different persons.
AppimageKit is designed with “upstream packaging” in mind. This means that we want the original author of an application to be the person that packages it as an AppImage, distributes it to end users, and supports it.

In this regard, if image is very similar to an `.exe` file on Windows or a `.dmg` file on the Mac. These files are normally prepared by the original application authors rather than by third parties. This ensures that the software works exactly the way the original application author has envisioned it to work. It also means that the application author does not have to follow arbitrary rules set by Linux distributions.

So before your package an application as an AppImage, ask yourself whether you are either the application author or a member of the application team. If not, it is most likely better to ask the original author of the application or the application team to provide an official AppImage.
