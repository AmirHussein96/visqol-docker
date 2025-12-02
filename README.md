# ViSQOL Python Container — Build & Usage Guide

This repository provides a Dockerized environment for building and running **ViSQOL** with full **Python bindings**, supporting both audio and speech quality evaluation.

---

## 1. Build the Docker Image

Create a new directory and place the `Dockerfile` inside it.

Then build:

```
bash
docker build --no-cache -t visqol-python:latest .
```
## 2. Test the Container

Start an interactive shell inside the image:

```
docker run -it visqol-python:latest bash
```

- Quick Python Test

```
python3 - << 'EOF'
from visqol import visqol_lib_py
from visqol.pb2 import visqol_config_pb2
print("Python ViSQOL API loaded successfully!")
EOF
```

- Test command line visqol:

```
visqol --help
```

- more rigorous test:

Run the container with your current directory mounted to `/data`:

    ```
    docker run -it -v $(pwd):/data visqol-python:latest bash
    ```

Then inside the container, execute:

``` 
    python /data/test_visqol.py
```

You should see output similar to:

```
testing visqol: tensor([2.9684], dtype=torch.float64)
testing mel: 5.207100868225098
testing sisdr: -19.987518310546875
```


## 3. Push the Image to Docker Hub

Tag the image:

```
docker tag visqol-python:latest amirhussein96/visqol-python:latest
```
Push it:

```
docker push amirhussein96/visqol-python:latest
```

## 4. Use the Image with Enroot

- Import from Docker Hub: `enroot import -o visqol-python.sqsh docker://amirhussein96/visqol-python-fixed:latest`
- Create the rootfs: `enroot create visqol-python.sqsh`
- Start the container: `enroot start visqol-python`
