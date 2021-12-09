
# devops-netology
hello world!

в корневом .gitignore будут проригнорированны все файлы с расширение .exe

В .gitignore из папки terraform будет проигнорированно:

**/.terraform/* - директории с именем.terraform и все их поддиректории, в любом каталоге проекта

*.tfstate - файлы типа .tfstate

*.tfstate.* - файлы всех типов,  содержащие в названии .tfstate.

crash.log - файлы crash.log 

*.tfvars - файлы типа .tfvars

override.tf и override.tf.json - файлы со строгим названием override.tf и файлы со строгим названием override.tf.json

*_override.tf и *_override.tf.json - файлы имеющие в окончании _override.tf и файлы имеющие в окончании _override.tf.json

.terraformrc - файлы со строгим названием .terraformrc

terraform.rc - файлы со строгим названием terraform.rc
