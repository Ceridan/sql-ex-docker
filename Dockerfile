FROM mcr.microsoft.com/mssql/server:2022-latest

ENV ACCEPT_EULA Y
ENV MSSQL_PID Developer
ENV SA_PASSWORD Pa\$\$w0rd

COPY ./db_scripts/ .

RUN ( /opt/mssql/bin/sqlservr --accept-eula & ) | grep -q "Service Broker manager has started" \
    && /opt/mssql-tools/bin/sqlcmd -S localhost -U SA -P $SA_PASSWORD -i ./aero_script.sql \
    && /opt/mssql-tools/bin/sqlcmd -S localhost -U SA -P $SA_PASSWORD -i ./computer_script.sql \
    && /opt/mssql-tools/bin/sqlcmd -S localhost -U SA -P $SA_PASSWORD -i ./inc_out_script.sql \
    && /opt/mssql-tools/bin/sqlcmd -S localhost -U SA -P $SA_PASSWORD -i ./painting_script.sql \
    && /opt/mssql-tools/bin/sqlcmd -S localhost -U SA -P $SA_PASSWORD -i ./ships_script.sql \
    && /opt/mssql-tools/bin/sqlcmd -S localhost -U SA -P $SA_PASSWORD -i ./computer_dml_script.sql \
    && /opt/mssql-tools/bin/sqlcmd -S localhost -U SA -P $SA_PASSWORD -i ./ships_dml_script.sql \
    && pkill sqlservr 

EXPOSE 1433
