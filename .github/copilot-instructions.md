**Repository Summary**
- **Purpose:**: Simple single-class Java example packaged with Docker.
- **Key files:**: `src/Main.java`, `Dockerfile`, `README.md`.

**Big Picture**
- **Architecture:**: Single-process Java app. Source lives in `src/` as a single top-level class `Main`. The app is compiled with `javac` and executed with the JVM inside a Docker container based on `openjdk:17-jdk-alpine`.
- **Why this layout:**: Minimal example demonstrating how to compile a Java source file and run it from a Docker image without a build system (no Maven/Gradle).

**Developer Workflows (concrete commands)**
- **Build locally (compile):**: `javac src/Main.java` — produces a `Main.class` in `src/`.
- **Run locally (no Docker):**: `java -cp src Main`.
- **Build Docker image:**: `docker build -t java-app .` (run from repo root).
- **Run Docker container:**: `docker run --rm java-app`.

**Project-specific conventions & patterns**
- **No build tool:**: This repo intentionally omits Maven/Gradle. Expect raw `javac` compilation and `java -cp` invocation. If you add packages, convert to standard `src/main/java` layout or add a build tool.
- **Source path:**: Sources are under `src/` (single file `src/Main.java`). Refer to `Main` as the main class.
- **Docker image intent:**: The `Dockerfile` should compile Java in the image and set the `CMD` to run the compiled class. Watch for path and JSON syntax issues (examples below).

**Common gotchas (seen in this repo)**
- **Wrong Java path in `javac` command:**: The `Dockerfile` currently uses `RUN javac src/main.java` but the file is `src/Main.java`. Use correct casing and path: `RUN javac src/Main.java`.
- **CMD JSON syntax error:**: The current `CMD` is `CMD ["java", "Main]` — missing closing quote. Correct form: `CMD ["java", "-cp", "src", "Main"]` (explicit classpath avoids ambiguity).
- **Classpath vs working dir:**: Either compile into the `src/` folder and use `-cp src` or create a dedicated `bin/` output directory and use that in `CMD`.

**Example corrected `Dockerfile` snippet**
Use this pattern for this minimal project:

```dockerfile
FROM openjdk:17-jdk-alpine
WORKDIR /app
COPY . /app
RUN javac src/Main.java
CMD ["java", "-cp", "src", "Main"]
```

**When editing code or tests**
- **Be explicit:**: Reference `src/Main.java` and update `Dockerfile` examples when you change class names or packages.
- **If adding dependencies:**: Add a build tool (Gradle or Maven) and update the `Dockerfile` to build artifacts (e.g., run `./gradlew build` and use the produced JAR).

**Integration points & external dependencies**
- **Docker:**: Image base is `openjdk:17-jdk-alpine`. Keep image lightweight but ensure needed JDK tooling is available for `javac`.
- **No external libraries**: This repo currently doesn't use external libraries; if you add any, update the Dockerfile and include dependency resolution/build step.

**Examples to reference while coding**
- **Run compile locally:**: `javac src/Main.java && java -cp src Main`
- **Build + run in Docker:**: `docker build -t java-app .; docker run --rm java-app` (PowerShell: use `;` between commands).

**Editing rules for AI agents**
- **Keep changes minimal and testable:**: Make small edits, update `Dockerfile` if source paths or class names change, and provide the explicit `docker build` and `docker run` commands in PR descriptions.
- **Prefer concrete file references:**: When modifying behavior, reference `src/Main.java` and `Dockerfile` lines in your commit message.
- **Don't introduce a build system silently:**: If converting to Maven/Gradle, add the new files (`pom.xml` or `build.gradle`) and update `README.md` and `Dockerfile` accordingly.

**Where to ask for clarification**
- If behavior relies on a CI pipeline or additional runtime args, ask the repo owner before guessing. The `README.md` is minimal and contains no CI details.

If any of the above assumptions are incorrect (for example, you intended a multi-file Java project or CI flow), tell me which direction to follow and I'll update the instructions.
