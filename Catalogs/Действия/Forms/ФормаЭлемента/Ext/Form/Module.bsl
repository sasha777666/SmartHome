﻿
&НаСервере
Процедура ВыполнитьДействиеНаСервере()
	ОбработкаОбъект = РеквизитФормыВЗначение("Объект");
	Ответ = ОбработкаОбъект.ВыполнитьДействие(); 
	ЗначениеВРеквизитФормы(ОбработкаОбъект, "Объект");
КонецПроцедуры

&НаКлиенте
Процедура ВыполнитьДействие(Команда)
	ВыполнитьДействиеНаСервере();
КонецПроцедуры
