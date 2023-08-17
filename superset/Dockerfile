FROM apache/superset:latest

USER root

RUN pip install pip -U && pip install pip-tools

RUN chown -R superset /app

WORKDIR /app

RUN pip install psycopg2-binary

ENV ADMIN_USERNAME $ADMIN_USERNAME
ENV ADMIN_EMAIL $ADMIN_EMAIL
ENV ADMIN_PASSWORD $ADMIN_PASSWORD

COPY ./superset-init.sh /app/superset-init.sh
RUN chmod +x /app/superset-init.sh  # Ensure script is executable

COPY superset_config.py /app/

ENV SUPERSET_CONFIG_PATH /app/superset_config.py

USER superset
ENTRYPOINT [ "/app/superset-init.sh" ]