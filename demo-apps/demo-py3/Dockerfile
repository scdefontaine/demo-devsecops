ARG BASE_IMAGE=python:3.10
ARG PLATFORM_ARCH=amd64
FROM --platform=${PLATFORM_ARCH} ${BASE_IMAGE} as builder

WORKDIR /app

COPY ./requirements.txt ${WORKDIR}/requirements.txt
RUN pip install --no-cache-dir --upgrade -r ${WORKDIR}/requirements.txt

COPY ./src ${WORKDIR}/app

CMD ["uvicorn", "main:app", "--host", "0.0.0.0", "--port", "5000", "--log-level", "info"]
