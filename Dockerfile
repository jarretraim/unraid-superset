FROM apache/superset:latest

USER root
COPY entrypoint-unraid.sh /entrypoint-unraid.sh
RUN chmod +x /entrypoint-unraid.sh
USER superset

ENTRYPOINT ["/entrypoint-unraid.sh"]