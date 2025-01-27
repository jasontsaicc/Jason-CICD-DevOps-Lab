# 第一階段：構建階段 (Builder)
FROM python:3.11-slim-bullseye AS builder

# 設置環境變數
ENV PYTHONDONTWRITEBYTECODE 1
ENV PYTHONUNBUFFERED 1

WORKDIR /app

# 安裝構建所需的工具（例如 gcc 用於構建某些依賴包）
RUN apt-get update && apt-get install -y --no-install-recommends \
    build-essential \
    libpq-dev && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# 複製需求文件並安裝依賴
COPY requirements.txt /app/
RUN pip install --upgrade pip
RUN pip install --upgrade setuptools
RUN pip install --no-cache-dir -r requirements.txt

# 複製應用代碼到構建階段
COPY . /app/


# 第二階段：運行階段 (Runtime)
FROM python:3.11-slim-bullseye

ENV PYTHONDONTWRITEBYTECODE 1
ENV PYTHONUNBUFFERED 1

WORKDIR /app

# 複製第一階段安裝的依賴到運行階段
COPY --from=builder /usr/local/lib/python3.11/site-packages /usr/local/lib/python3.11/site-packages
COPY --from=builder /usr/local/bin /usr/local/bin

# 複製應用代碼（僅必要部分）
COPY --from=builder /app /app

EXPOSE 8058

# 使用 Gunicorn 啟動
CMD ["gunicorn", "--bind", "0.0.0.0:8058", "django_devops_portal.wsgi:application"]
