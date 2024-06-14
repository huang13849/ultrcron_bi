# Use the official Superset image as the base image
FROM apache/superset

# Install PostgreSQL driver
RUN pip install psycopg2-binary

# Run the original entrypoint
ENTRYPOINT ["docker-entrypoint.sh"]