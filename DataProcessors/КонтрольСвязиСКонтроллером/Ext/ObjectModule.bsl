﻿Процедура ПроцессДляСервера(Процесс = "") Экспорт // Записывается в процессы НазваниеПроцедуры
	
	Инициализация();	
	ПолучитьТекущиеДанные(); 
	ВыполнитьИтерацию();
	ЗаписатьТекущиеДанные();
	
КонецПроцедуры
Процедура Инициализация() Экспорт
	
	Ответ = ЗаполнитьНастройки();
	Если ЗначениеЗаполнено(Ответ) Тогда 
		Сообщения = Сообщения + Символы.ПС + ТекущаяДата() + " " + Ответ;
	КонецЕсли;
	
	Ответ = ПроверитьОткрытьПортСвязь();
	Если ЗначениеЗаполнено(Ответ) Тогда 
		Сообщения = Сообщения + Символы.ПС + ТекущаяДата() + " " + Ответ;
	КонецЕсли;
	
		
КонецПроцедуры
Процедура ВыполнитьИтерацию() Экспорт	
	
	ТаймерСброшен = К.АвтоСброс(Оборудование, НастройкаВремяТаймера);
	ДатаТаймерСброшен = ТекущаяДата();
	
	Если ТаймерСброшен = Истина Тогда
		ПоследнийУспешныйСбросТаймера = ТекущаяДата();
	Иначе			
		Сообщения = Сообщения + "Ошибка при сбросе таймера " + ТекущаяДата() + "; ";
	КонецЕсли;
		
КонецПроцедуры



Функция ЗаполнитьНастройки() Экспорт
	
	СообщениеСНенайденнымиНастройками = "";
	
	// Настройки в реквизитах
	СтрокаСТабСНастройкамиРеквизитов = Оборудование.Настройки.Найти("Реквизиты",  "Наименование");
	Если СтрокаСТабСНастройкамиРеквизитов = Неопределено Тогда 
		СообщениеСНенайденнымиНастройками = СообщениеСНенайденнымиНастройками + "Не заполнена настройка для реквизитов (В справочнике оборудование); ";
	Иначе
		ТабСНастройкамиРеквизитов = СтрокаСТабСНастройкамиРеквизитов.Настройка.ТаблицаНастроек;
		
		СтрокаСПараметром = ТабСНастройкамиРеквизитов.Найти("НастройкаВремяТаймера", "Параметр");
		Если СтрокаСПараметром = Неопределено Тогда 
			СообщениеСНенайденнымиНастройками = СообщениеСНенайденнымиНастройками + "Не указан параметр ""НастройкаВремяТаймера""; ";
		Иначе
			НастройкаВремяТаймера = СтрокаСПараметром.Значение;
		КонецЕсли;
	КонецЕсли;	
	
	Возврат СообщениеСНенайденнымиНастройками;	

КонецФункции
Функция ПроверитьОткрытьПортСвязь()
	
	Ответ = "";
	Если ТипЗнч(Оборудование.КонтроллерCOMNET) = Тип("СправочникСсылка.КонтроллерыCOM") Тогда // COM
		ПроверкаСвязи = К.ПроверитьКомпонентуИСвязьCOMПорта(Оборудование.КонтроллерCOMNET.НомерCOMПорта, Истина);
		Если ПроверкаСвязи = Неопределено Тогда 
			Ответ = Ответ + "Сбой при выполнении проверки связи (Компоненты). Порт: " + Оборудование.КонтроллерCOMNET.НомерCOMПорта + " ;";	
		ИначеЕсли ПроверкаСвязи = 1 Тогда //Компонента есть, ком порт открыт и работает
			// Ничего не делаем всё ОК
		ИначеЕсли ПроверкаСвязи = 2 Тогда // Нет компоненты, нужно открыть ком порт
			ПортОткрыт = К.ОткрытьCOMПорт(Оборудование.КонтроллерCOMNET.НомерCOMПорта, Оборудование.КонтроллерCOMNET.СкоростьCOMПорта);
			Если ПортОткрыт = Неопределено или Не ПортОткрыт Тогда 
		    	Ответ = Ответ + "Не удалось открыть COM порт номер: " + Оборудование.КонтроллерCOMNET.НомерCOMПорта + " ;";
			КонецЕсли;
			ПроверкаСвязи = К.ВыполнитьКоманду(Оборудование.КонтроллерCOMNET.НомерCOMПорта, 0, 254, 77);
			Если ПроверкаСвязи.ОтветСтатус <> 254 или ПроверкаСвязи.ОтветАргумент1 <> 77 Тогда
				Ответ = Ответ + "Не пройдена проверка связи; ";	
			КонецЕсли;		
		ИначеЕсли ПроверкаСвязи = 3 Тогда // Не пройдена проверка связи, Пересоздаём компоненту и открываем порт
			ПортОткрыт = К.ПересоздатьКомпонентуИОткрытьCOMПорт(Оборудование.КонтроллерCOMNET.НомерCOMПорта, Оборудование.КонтроллерCOMNET.СкоростьCOMПорта);
			Если ПортОткрыт = Неопределено или Не ПортОткрыт Тогда 
		    	Ответ = Ответ + "Не удалось открыть COM порт номер: " + Оборудование.КонтроллерCOMNET.НомерCOMПорта + " ;";
			КонецЕсли;
			ПроверкаСвязи = К.ВыполнитьКоманду(Оборудование.КонтроллерCOMNET.НомерCOMПорта, 0, 254, 77);
			Если ПроверкаСвязи.ОтветСтатус <> 254 или ПроверкаСвязи.ОтветАргумент1 <> 77 Тогда
				Ответ = Ответ + "Не пройдена проверка связи; ";	
			КонецЕсли;	
		КонецЕсли;
	Иначе // NET
		ПроверкаСвязи = К.ВыполнитьКоманду(Оборудование.КонтроллерCOMNET.АдресПорт, 0, 254, 77);
		Если ПроверкаСвязи.ОтветСтатус <> 254 или ПроверкаСвязи.ОтветАргумент1 <> 77 Тогда
			Ответ = Ответ + "Не пройдена проверка связи; ";	
		КонецЕсли;		
	КонецЕсли;
	
	Возврат Ответ;
			
КонецФункции


Процедура ПолучитьТекущиеДанные() Экспорт
	
	Запрос = Новый Запрос();
	Запрос.Текст = "ВЫБРАТЬ
	               |	ТекущиеДанныеОборудования.ОбъектДанных,
	               |	ТекущиеДанныеОборудования.Данные,
	               |	ТекущиеДанныеОборудования.Дата
	               |ИЗ
	               |	РегистрСведений.ТекущиеДанныеОборудования КАК ТекущиеДанныеОборудования
	               |ГДЕ
	               |	ТекущиеДанныеОборудования.Оборудование = &Оборудование";
	Запрос.УстановитьПараметр("Оборудование", Оборудование);
	Выборка = Запрос.Выполнить().Выбрать();
	Пока Выборка.Следующий() Цикл		
		КодВыполнения = "" + СокрЛП(Выборка.ОбъектДанных) + " = Выборка.Данные;
		|Дата" + СокрЛП(Выборка.ОбъектДанных) + " = Выборка.Дата;"; 
		Попытка
			Выполнить(КодВыполнения);
		Исключение
			Сообщения = Сообщения + Символы.ПС + "Ошибка при заполнении реквизита = " + Выборка.ОбъектДанных + ". Ошибка = " + ОписаниеОшибки();		
		КонецПопытки;		
	КонецЦикла;
			   
КонецПроцедуры
Процедура ЗаписатьТекущиеДанные()
	
	//ТаймерСброшен
	Менеджер = РегистрыСведений.ТекущиеДанныеОборудования.СоздатьМенеджерЗаписи();
	Менеджер.Оборудование = Оборудование;
	Менеджер.ОбъектДанных = "ТаймерСброшен";
	Менеджер.Данные = ТаймерСброшен;
	Менеджер.Дата = ТекущаяДата();
	Менеджер.Записать(Истина);	
	
	//ПоследнийУспешныйСбросТаймера
	Менеджер = РегистрыСведений.ТекущиеДанныеОборудования.СоздатьМенеджерЗаписи();
	Менеджер.Оборудование = Оборудование;
	Менеджер.ОбъектДанных = "ПоследнийУспешныйСбросТаймера";
	Менеджер.Данные = ПоследнийУспешныйСбросТаймера;
	Менеджер.Дата = ТекущаяДата();
	Менеджер.Записать(Истина);
	
КонецПроцедуры

