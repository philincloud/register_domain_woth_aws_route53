#!bin/bash

domain=$(head -2 ./register-domain.json | sed -r -e's/DomainName//' -e 's/[\{\:\"\,]//g' ) 

domain=$(echo $domain | sed 's/ //g')

result=$(aws route53domains list-domains --region us-east-1 --query "Domains[?DomainName=='$(echo $domain)'].DomainName" --output text)

if [[ $domain == '$result' ]]
then
    echo "You already registered this domain"
else
    echo "Do you want to register the '"$domain"' domain? AWS Route53 charges apply. (yes/no)"

    read answer

    

    if [[ $answer == "yes" ]]
    then
        echo "Please confirm if given data is correct: "
        sleep 0.5
        cat ./modules/data/register-domain.json
        echo "Do you want to proceed with the registration? (yes/no)"
        read answer
        if [[ $answer == "yes" ]]
        then
            echo "Registering domain..."
            aws route53domains register-domain --region us-east-1 --cli-input-json file://modules/data/register-domain.json --output json
        fi    
        if [[ $answer == "no" ]]
        then
            echo "Please edit /module/data/register-domain.json file."
        fi    

    fi
     if [[ $answer == "no" ]]
    then
        echo "Domain registration cancelled."
    fi  
    
fi
