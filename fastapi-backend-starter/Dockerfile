# Use an official Python runtime as a parent image
FROM python:3.8-slim-buster

# Set the working directory in the container
WORKDIR /usr/src/app

# Install FastAPI and Uvicorn
RUN pip install --no-cache-dir fastapi uvicorn
RUN pip install propelauth-fastapi
# Make port 8000 available to the world outside this container
EXPOSE 3001

# Run app.py when the container launches
CMD ["uvicorn", "app:app", "--host", "0.0.0.0", "--port", "3001", "--reload"]
