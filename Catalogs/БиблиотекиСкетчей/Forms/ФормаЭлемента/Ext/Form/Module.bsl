﻿
&НаКлиенте
Процедура ПутьКФайлуВРабочемКаталогеНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	Режим = РежимДиалогаВыбораФайла.Открытие;
	ДиалогОткрытия = Новый ДиалогВыбораФайла(Режим);
	ДиалогОткрытия.ПолноеИмяФайла = ПолучитьРабочийКаталог() + Объект.ПутьКФайлуВРабочемКаталоге;
	ДиалогОткрытия.МножественныйВыбор = Ложь;
	ДиалогОткрытия.Заголовок = "Выберете файл";
	ОписаниеОповещения = Новый ОписаниеОповещения("ПродолжениеВыбораФайла",ЭтаФорма);

	ДиалогОткрытия.Показать(ОписаниеОповещения);
	
КонецПроцедуры

&НаСервере
Функция ПолучитьРабочийКаталог()
	Возврат Константы.КаталогФайловРабочий.Получить();	
КонецФункции


&НаКлиенте
Процедура ПродолжениеВыбораФайла(ВыбранныеФайлы, Параметры) Экспорт
	
	Если ЗначениеЗаполнено(ВыбранныеФайлы) Тогда		
		Объект.ПутьКФайлуВРабочемКаталоге = Сред(ВыбранныеФайлы[0],СтрДлина(ПолучитьРабочийКаталог())+1);
	КонецЕсли;
		
КонецПроцедуры

	
	