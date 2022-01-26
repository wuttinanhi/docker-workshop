FROM ubuntu as base

# install python3
RUN apt update -y \
    && apt upgrade -y \ 
    && apt install software-properties-common -y \
    && add-apt-repository universe \
    && apt install python3 -y \ 
    && apt install python3-pip -y

FROM base as pip_install

# pip install fastapi uvicorn
RUN pip install fastapi \
    && pip install uvicorn

FROM pip_install as main

# add user python
RUN useradd python

# make project directory
RUN mkdir -p /project/python

# change directory to project directory
WORKDIR /project/python/

# copy project file
COPY --chown=python . .

# # change permission of directory
# RUN chmod -R 770 /project/python/

# # add user to directory permission
# RUN chown -R python /project/python/

# expose port 80
EXPOSE 80

# change user to python
USER python

# start command
CMD uvicorn index:app --host 0.0.0.0 --port 80
