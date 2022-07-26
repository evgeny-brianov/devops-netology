**1.** Ссылки на значения в исходном коде:

[resource](https://github.com/hashicorp/terraform-provider-aws/blob/daf6ea60dd367697481ee604e219c1f0d9db0af2/internal/provider/provider.go#L913)

[data_source](https://github.com/hashicorp/terraform-provider-aws/blob/daf6ea60dd367697481ee604e219c1f0d9db0af2/internal/provider/provider.go#L415)

**2.** Вопросы по параметру name ресурса aws_sqs_queue:

[Ссылка на конфликт](https://github.com/hashicorp/terraform-provider-aws/blob/daf6ea60dd367697481ee604e219c1f0d9db0af2/internal/service/sqs/queue.go#L87)

[Максимальная длина имени составляет 80 символов](https://github.com/hashicorp/terraform-provider-aws/blob/daf6ea60dd367697481ee604e219c1f0d9db0af2/internal/service/sqs/queue.go#L427)

Шаблон для параметра name подчиняется следующим правилам именования:
* строчные латинские буквы a-z
* Заглавные латинские буквы A-Z
* цифры 0-9
* нижнее подчеркивание и дефис _-
