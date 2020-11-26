# multi scala modules example with Maven

Example of multi scala projects with [Maven(3.6.3)](https://maven.apache.org/) and plugins:

- [maven-assembly-plugin](http://maven.apache.org/plugins/maven-assembly-plugin/)
    The Assembly Plugin for Maven enables developers to combine project output into a single distributable archive that also contains dependencies, modules, site documentation, and other files.

- [flatten-maven-plugin](https://www.mojohaus.org/flatten-maven-plugin/)
    The Flatten Maven Plugin generates a flattened version of the pom.xml that Maven installs and deploys instead of the original.

## Project Structure
```bash
.
├── A
│   ├── pom.xml # base module, dep on `nscala-time_2.12`
│   └── src
├── B
│   ├── pom.xml # dep on A
│   └── src
├── C
│   ├── pom.xml # dep on A
│   └── src
├── D
│   ├── pom.xml # dep on B, C
│   └── src
├── P
│   └── pom.xml # parent project
├── README.md
└── pom.xml # root project
```

## Build Examples
```bash

# build jar with dependencies for module B only
./bin/build.sh assembly B
# B-assembly-jar-with-dependencies.jar

# build jar with dependencies for module A, B
./bin/build.sh assembly A B
# A-assembly-jar-with-dependencies.jar
# B-assembly-jar-with-dependencies.jar

# build jar **without** dependencies for all modules
./bin/build.sh package all
# A-1.0-SNAPSHOT.jar
# B-1.0-SNAPSHOT.jar
# C-1.0-SNAPSHOT.jar
# D-1.0-SNAPSHOT.jar
```
