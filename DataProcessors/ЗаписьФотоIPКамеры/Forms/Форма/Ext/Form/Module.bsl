﻿
&НаСервере
Процедура ВыполнитьИнтерациюНаСервере()
	ОбработкаОбъект = РеквизитФормыВЗначение("Объект");
	ОбработкаОбъект.ПроцессДляСервера(); 
	ЗначениеВРеквизитФормы(ОбработкаОбъект, "Объект");
КонецПроцедуры

&НаКлиенте
Процедура ВыполнитьИнтерацию(Команда)
	ВыполнитьИнтерациюНаСервере();
КонецПроцедуры
