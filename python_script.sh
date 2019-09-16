
#!/bin/bash

source .env

echo_statement() {
  echo ""
  echo -e "\033[0;35m ========== ${1} =========== \033[0m"
}

install_python() {
  echo_statement "Setting up python environment"
  sudo sh -c 'echo "deb http://apt.postgresql.org/pub/repos/apt/ `lsb_release -cs`-pgdg main" >> /etc/apt/sources.list.d/pgdg.list'
  sudo apt-get update
  sudo apt-get -y install python3-pip
}

GitHub_Repo="https://github.com/vic3king/Politico-python.git"
clone_github_repo() {
  echo_statement "Cloning github repository"
  if [[ -d Politico-python ]]; then
    sudo rm -rf Politico-python
  fi
  git clone ${GitHub_Repo}
}

install_dependencies() {
  echo_statement "Installing project dependencies"
  cd Politico-python
  pip3 install -r requirements.txt
  python3 manage.py db upgrade
}

Domain=politico-api.tk
www_Domain=www.politico-api.tk
Email=vic3coorp@gmail.com
config_server="
  server  {
    server_name ${Domain} ${www_Domain};
    location / {
      proxy_pass http://127.0.0.1:5000;
    }
  }
"

configure_NGINX() {
  echo_statement "Configuring NGINX reverse proxy server"
  sudo apt-get install nginx -y
  sudo rm -r /etc/nginx/sites-enabled/default
  sudo echo ${config_server} > /etc/nginx/sites-available/Politico-python
  sudo ln -s /etc/nginx/sites-available/Politico-python /etc/nginx/sites-enabled/Politico-python
  sudo service nginx restart
}

configure_SSL() {
  echo_statement "Configuring SSL Certificate"
  sudo apt-get update
  sudo apt-get install software-properties-common
  sudo add-apt-repository ppa:certbot/certbot -y
  sudo apt-get update
  sudo apt-get install certbot python-certbot-nginx -y
  sudo certbot --nginx  -d ${Domain} -d ${www_Domain} -m ${Email} --agree-tos --non-interactive
}

start_script='
  {
    "apps": [
      {
        "name": "Politico-backend",
        "script": "python3",
        "args": "manage.py runserver"
      }
    ]
  }
'

keep_App_Alive() {
  echo_statement "Install PM2 to run app in background"
#   cd Politico-python
  echo ${PWD} "------------------"
  # sudo npm install pm2 -g
  #sudo echo ${start_script} > ./start_script.config.json
  #pm2 start start_script.config.json
  python3 manage.py runserver
}
                                                                       main() {
  install_python
  clone_github_repo
  install_dependencies
#   build_webpack
#   configure_NGINX
#   configure_SSL
  keep_App_Alive
}
main

export APP_SETTINGS="development"
export SECRET_KEY="some-very-long-st5ring-of-rfghvbjknandom-characters"
export DEV_DATABASE_URL="postgres://qpohlxfj:JCVTOzx8DxG3gu2CosCHo9fIPe678Sik@raja.db.elephantsql.com:5432/qpohlxfj"
export TEST_DATABASE_URL="postgres://postgres:postgres@localhost:5432/politico"
export DATABASE_URL="postgres://qpohlxfj:JCVTOzx8DxG3gu2CosCHo9fIPe678Sik@raja.db.elephantsql.com:5432/qpohlxfj"
export GOOGLE="AIzaSyCuprhlOtAFpOfhaYMs5fYdjdnnla57BLg"