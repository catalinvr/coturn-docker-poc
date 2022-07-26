FROM openjdk:11-jdk-slim AS cert_builder
WORKDIR /opt/workdir/

RUN keytool -genkey -noprompt -keyalg RSA -alias gasper -dname "CN=test.tremend.com, OU=ID, O=Tremend, L=Bucharest, S=Bucharest, C=RO" -keystore keystore.jks -storepass welcome -validity 360 -keysize 2048
RUN keytool -export -noprompt -alias gasper -file root.cer -keystore keystore.jks -storepass welcome
RUN keytool -import -noprompt -alias gasper -file root.cer -keystore truststore.jks -storepass welcome
RUN openssl x509 -inform der -in root.cer -out certificate.pem
RUN keytool -importkeystore -srckeystore keystore.jks -destkeystore keystore.p12 -srcstoretype JKS -deststoretype PKCS12 -deststorepass sonus123 -srcstorepass welcome
RUN openssl pkcs12 -in keystore.p12 -out keyStore.pem -nodes -nocerts -passin pass:sonus123
RUN cp keyStore.pem turn_server_pkey.pem
RUN cp certificate.pem turn_server_cert.pem
RUN chmod 777 turn_server_pkey.pem
RUN chmod 777 turn_server_cert.pem

FROM coturn/coturn:4.5.2

USER root
RUN mkdir -p /etc/coturn/certs \
    && chown -R nobody:nogroup /etc/coturn/ \
    && chmod -R 700 /etc/coturn/ 

COPY --from=cert_builder /opt/workdir/turn_server_cert.pem /etc/coturn/certs/cert.pem
COPY --from=cert_builder /opt/workdir/turn_server_pkey.pem /etc/coturn/certs/privkey.pem
RUN apt update && apt install -y procps iputils-ping telnet mariadb-client net-tools
RUN chmod 777 /etc/coturn/certs/cert.pem && chmod 777 /etc/coturn/certs/privkey.pem
RUN chown nobody:nogroup /etc/coturn/certs/cert.pem && chown nobody:nogroup /etc/coturn/certs/privkey.pem

USER nobody:nogroup