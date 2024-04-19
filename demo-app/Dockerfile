ARG BASE_IMAGE=python:3.10
ARG PLATFORM_ARCH=amd64
FROM --platform=${PLATFORM_ARCH} ${BASE_IMAGE}

WORKDIR /app

ARG CPU_LIMIT=2
ARG MEM_LIMIT=2048m
ARG ADDITIONAL_PACKAGES=""

ENV APP_CPU_LIMIT=$CPU_LIMIT
ENV APP_MEM_LIMIT=$MEM_LIMIT

COPY ./requirements.txt ${WORKDIR}/requirements.txt
RUN pip install --no-cache-dir --upgrade -r ${WORKDIR}/requirements.txt
RUN if [ -n "$ADDITIONAL_PACKAGES" ]; then pip install "$ADDITIONAL_PACKAGES"; fi

COPY ./src ${WORKDIR}/app

CMD ["uvicorn", "main:app", "--host", "0.0.0.0", "--port", "5000", "--log-level", "info"]
