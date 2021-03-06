﻿
&НаКлиенте
Процедура ПовторениеОбработчикомОжиданияНаКлиенте()
	
	ПовторениеОбработчикомОжиданияНаСервере();	
	Если Объект.ИнтервалПовторенияКлиент > 0 Тогда
		ПодключитьОбработчикОжидания("ПовторениеОбработчикомОжиданияНаКлиенте", Объект.ИнтервалПовторенияКлиент, Истина);
	КонецЕсли;
	
КонецПроцедуры

	
&НаСервере
Процедура ПовторениеОбработчикомОжиданияНаСервере()
	
	ОбработкаОбъект = РеквизитФормыВЗначение("Объект");
	ОбработкаОбъект.ПолучитьТекущиеДанные(); 
	ЗначениеВРеквизитФормы(ОбработкаОбъект, "Объект");

КонецПроцедуры

&НаКлиенте
Процедура ВключитьМониторинг(Команда)
	
	ПодключитьОбработчикОжидания("ПовторениеОбработчикомОжиданияНаКлиенте", Объект.ИнтервалПовторенияКлиент, Истина);
	
КонецПроцедуры

&НаСервере
Процедура ВыполнитьНаСервере()
	
	ОбработкаОбъект = РеквизитФормыВЗначение("Объект");
	ОбработкаОбъект.ПроцессДляСервера(); 
	ЗначениеВРеквизитФормы(ОбработкаОбъект, "Объект");
	
КонецПроцедуры

&НаКлиенте
Процедура ВыполнитьИтерацию(Команда)
	ВыполнитьНаСервере();
КонецПроцедуры

&НаСервере
Процедура ЗадатьШИМНаСервере()
	
	ОбработкаОбъект = РеквизитФормыВЗначение("Объект");
	ОбработкаОбъект.ЗадатьШИМ();
	ОбработкаОбъект.ЗаписатьТекущиеДанные();
	ЗначениеВРеквизитФормы(ОбработкаОбъект, "Объект");
	
КонецПроцедуры

&НаКлиенте
Процедура ЗадатьШИМКлиент(Команда)
	ЗадатьШИМНаСервере();
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьПиныИНастройкиНаСервере()
	ОбработкаОбъект = РеквизитФормыВЗначение("Объект");
	ОбработкаОбъект.ЗаполнитьПины();
	ОбработкаОбъект.ЗаполнитьНастройки();
	ЗначениеВРеквизитФормы(ОбработкаОбъект, "Объект");

КонецПроцедуры

&НаКлиенте
Процедура ЗаполнитьПиныИНастройки(Команда)
	ЗаполнитьПиныИНастройкиНаСервере();
КонецПроцедуры



