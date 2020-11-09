**How it works:**
- All python files in dockerbatchtemplate will be built as wheel
- The main entry is in cli

**Build Docker Image:**

- sudo docker build --build-arg TOKEN=<github token> -t <image_name> .

**Run this docker:**

- The entry point is cli.

- command:


- **RUN**
    - sudo docker run <image_name> demo1 --content hello_1
    - sudo docker run <image_name> demo2 --content hello_2









