FROM ghcr.io/astral-sh/uv:python3.13-trixie

COPY ./factaudit/pyproject.toml /factaudit/pyproject.toml
COPY ./factaudit/uv.lock /factaudit/uv.lock
WORKDIR /factaudit
RUN uv sync --frozen --no-install-project -i https://mirrors.aliyun.com/pypi/simple/

COPY ./factaudit /factaudit
RUN uv sync --frozen -i https://mirrors.aliyun.com/pypi/simple/

ENV TZ=Asia/Shanghai
