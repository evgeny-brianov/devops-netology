**1.** Скачиваем Go
```
[almanax@alma8 7.5]$ wget https://go.dev/dl/go1.18.4.linux-amd64.tar.gz
```
Распаковываем архив в каталог usr/local/bin
```
[almanax@alma8 7.5]$ sudo tar -C /usr/local -xf go1.18.4.linux-amd64.tar.gz
```
Чтобы система могла найти исполняемые файлы Go изменяем PATH
открываем **sudo nano ~/.bash_profile** и добавляем строчку:
```
export PATH=$PATH:/usr/local/go/bin
```
Загружаем новую переменную среды в текущий сеанс:
```
[almanax@alma8 7.5]$ source ~/.bash_profile
```
Проверяем установку:
```
[almanax@alma8 7.5]$ go version
go version go1.18.4 linux/amd64
```
**2.** 
Ознакомился с разделами **Packages, variables, and functions** и **Flow control statements: for, if, else, switch and defer**

В качестве IDE использовал Visual Studio Code с расширением Go Nightly

**3.** 
Перевод метров в футы:
```
package main

import "fmt"

func main() {
	fmt.Print("Укажите расстояние в метрах:")
	var m float64
	fmt.Scanf("%f", &m)

	var f float64
	f = m / 0.3048

	fmt.Println("\n В футах это будет: ")
	fmt.Println(f)
```
Наименьший элемент в заданном списке:
```
package main

import "fmt"

func main() {
	x := []int{48, 96, 86, 68, 57, 82, 63, 70, 37, 34, 83, 27, 19, 97, 9, 17}
	min := x[0]
	for _, v := range x {
		if v < min {
			min = v
		}
	}

	fmt.Println(min)
}
```
Числа диапазона, которые делятся на 3:
```
package main

import "fmt"

func main2() {
	fmt.Println("Числа от 1 до 100, которые делятся на 3 без остатка:")
	for i := 1; i <= 100; i++ {
		if i%3 == 0 {
			fmt.Println(i)
		}
	}

}
```
