FROM python:3
WORKDIR /usr/local
RUN pip install --root-user-action=ignore --upgrade pip && pip install --root-user-action=ignore django mysqlclient && mkdir static
COPY django_tutoriall /usr/local
COPY docker-entrypoint.sh /usr/local/
RUN chmod +x /usr/local/docker-entrypoint.sh
CMD /usr/local/docker-entrypoint.sh
