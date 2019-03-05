﻿
&НаКлиенте
Процедура ОбработкаКоманды(ПараметрКоманды, ПараметрыВыполненияКоманды)
	ОбработкаКомандыСервер(ПараметрКоманды);
КонецПроцедуры

&НаСервере
Процедура ОбработкаКомандыСервер(ПараметрКоманды)
	
	Для Каждого ВыбранныйЭлемент Из ПараметрКоманды Цикл
		Если ЗначениеЗаполнено(ВыбранныйЭлемент) Тогда
			Если Справочники.ТипВсеСсылки().СодержитТип(ТипЗнч(ВыбранныйЭлемент)) Тогда // это справочник
				Интеграции.Обмен_ОтправитьДанныеСправочникаВЦентральнуюБазу(ВыбранныйЭлемент);	
			Иначе
			КонецЕсли;
		КонецЕсли;
	КонецЦикла;
	
КонецПроцедуры
