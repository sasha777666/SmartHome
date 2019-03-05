﻿Процедура ПроцессДляСервера(Процесс = "") Экспорт // Записывается в процессы НазваниеПроцедуры
	
	Инициализация();	
	//Получить тек данные
	ВыполнитьИтерацию();
	ЗаписатьТекущиеДанные();
	
КонецПроцедуры
Процедура Инициализация() Экспорт
	
	Ответ = ЗаполнитьПины();
	Если ЗначениеЗаполнено(Ответ) Тогда 
		Сообщения = Сообщения + Символы.ПС + ТекущаяДата() + " " + Ответ;
	КонецЕсли;
	
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
	
	ОбновитьПоказанияМодульОбъекта();
	
	//Сравниваем с диапазоном допустимой температуры и управляем обогравателями
	//Основной
	Если НастройкаАктивнаАвтоматикаОсновногоОбогревателя Тогда // Если включена автоматика             
		Если ДатаТемператураДатчика3 + 10 >= ТекущаяДата() Тогда // Данные о температуре актуальны
			
			СоответствиеСопротивленияТемпературыТерморезитораMF52.Сортировать("Температура");	
			Если ТемператураДатчика3 = СоответствиеСопротивленияТемпературыТерморезитораMF52[0].Температура
				или ТемператураДатчика3 = СоответствиеСопротивленияТемпературыТерморезитораMF52[СоответствиеСопротивленияТемпературыТерморезитораMF52.Количество()-1].Температура Тогда
				// Предположительно сбой датчика, т.к. значение находится на границе диапазона. Отключаем нагреватель
				Реле1Вкл = Ложь;
			Иначе			
				Если ТемператураДатчика3 > НастройкаМаксТемператураОсновногоОбогревателя Тогда // Выключаем
					Реле1Вкл = Ложь;
				ИначеЕсли ТемператураДатчика3 < НастройкаМинТемператураОсновногоОбогревателя Тогда // Включаем
					Реле1Вкл = Истина;
				КонецЕсли;
			КонецЕсли;
		Иначе // не удалось получить температуру, отключаем
			Реле1Вкл = Ложь;         
			Сообщения = Сообщения + "Ошибка при получении температуры " + ТекущаяДата() + "; ";
		КонецЕсли;
	КонецЕсли;
	
	//Обогреватель АКБ
	Если НастройкаАктивнаАвтоматикаАКБОбогревателя Тогда // Если включена автоматика             
		Если ДатаТемператураДатчика2 + 10 >= ТекущаяДата() Тогда // Данные о температуре актуальны
			
			СоответствиеСопротивленияТемпературыТерморезитораMF52.Сортировать("Температура");	
			Если ТемператураДатчика2 = СоответствиеСопротивленияТемпературыТерморезитораMF52[0].Температура
				или ТемператураДатчика2 = СоответствиеСопротивленияТемпературыТерморезитораMF52[СоответствиеСопротивленияТемпературыТерморезитораMF52.Количество()-1].Температура Тогда
				// Предположительно сбой датчика, т.к. значение находится на границе диапазона. Отключаем нагреватель
				Реле3Вкл = Ложь;
			Иначе			
				Если ТемператураДатчика2 > НастройкаМаксТемператураАКБОбогревателя Тогда // Выключаем
					Реле3Вкл = Ложь;
				ИначеЕсли ТемператураДатчика2 < НастройкаМинТемператураАКБОбогревателя Тогда // Включаем
					Реле3Вкл = Истина;
				КонецЕсли;
			КонецЕсли;
		Иначе // не удалось получить температуру, отключаем
			Реле3Вкл = Ложь;         
			Сообщения = Сообщения + "Ошибка при получении температуры " + ТекущаяДата() + "; ";
		КонецЕсли;
	КонецЕсли;
	

	
	//Приминяем состояния реле
	Если УстановитьСостоянияРеле() <> Истина Тогда
		Сообщения = Сообщения + "Ошибка при установки состояний реле " + ТекущаяДата() + "; ";
	КонецЕсли;
		
	
КонецПроцедуры

Процедура ОбновитьПоказанияМодульОбъекта() Экспорт
	
	//Измеряем показания датчиков
	
	// ПинДатчикТемпературы1MF52
	Ответ = К._analogRead_СреднееАрифметическое(?( ТипЗнч(Оборудование.КонтроллерCOMNET) = Тип("СправочникСсылка.КонтроллерыCOM"), Оборудование.КонтроллерCOMNET.НомерCOMПорта, Оборудование.КонтроллерCOMNET.АдресПорт), ПинДатчикТемпературы1MF52, 2);
	Если ТипЗнч(Ответ) = Тип("Число") Тогда 
		Сопротивление = Конвертация.Сопротивление(Ответ, 9.83);	
		Если Сопротивление = 99999999999999999999999999999999 Тогда // Ошибка, возможно разрыв провода
			Сообщения = Сообщения + "Сбой датчика температуры 1 " + ТекущаяДата() + "; "; 
		КонецЕсли;
		ТемператураДатчика1 = ОпределитьТемпературуПоСопротивлению(Сопротивление);	
		ДатаТемператураДатчика1 = ТекущаяДата();
	КонецЕсли;	
	// ПинДатчикТемпературы2MF52
	Ответ = К._analogRead_СреднееАрифметическое(?( ТипЗнч(Оборудование.КонтроллерCOMNET) = Тип("СправочникСсылка.КонтроллерыCOM"), Оборудование.КонтроллерCOMNET.НомерCOMПорта, Оборудование.КонтроллерCOMNET.АдресПорт), ПинДатчикТемпературы2MF52, 2);
	Если ТипЗнч(Ответ) = Тип("Число") Тогда 
		Сопротивление = Конвертация.Сопротивление(Ответ, 9.83);	
		Если Сопротивление = 99999999999999999999999999999999 Тогда // Ошибка, возможно разрыв провода
			Сообщения = Сообщения + "Сбой датчика температуры 2 " + ТекущаяДата() + "; "; 
		КонецЕсли;
		ТемператураДатчика2 = ОпределитьТемпературуПоСопротивлению(Сопротивление);	
	  	ДатаТемператураДатчика2 = ТекущаяДата();
	КонецЕсли;
	// ПинДатчикТемпературы3MF52
	Ответ = К._analogRead_СреднееАрифметическое(?( ТипЗнч(Оборудование.КонтроллерCOMNET) = Тип("СправочникСсылка.КонтроллерыCOM"), Оборудование.КонтроллерCOMNET.НомерCOMПорта, Оборудование.КонтроллерCOMNET.АдресПорт), ПинДатчикТемпературы3MF52, 2);
	Если ТипЗнч(Ответ) = Тип("Число") Тогда 
		Сопротивление = Конвертация.Сопротивление(Ответ, 9.83);	
	    Если Сопротивление = 99999999999999999999999999999999 Тогда // Ошибка, возможно разрыв провода
			Сообщения = Сообщения + "Сбой датчика температуры 3 " + ТекущаяДата() + "; "; 
		КонецЕсли;
		ТемператураДатчика3 = ОпределитьТемпературуПоСопротивлению(Сопротивление);		
		ДатаТемператураДатчика3 = ТекущаяДата();
	КонецЕсли;
	// ПинДатчикТемпературы4DHT21
	Ответ = К._ТемператураВлажностьDHT21(?( ТипЗнч(Оборудование.КонтроллерCOMNET) = Тип("СправочникСсылка.КонтроллерыCOM"), Оборудование.КонтроллерCOMNET.НомерCOMПорта, Оборудование.КонтроллерCOMNET.АдресПорт), ПинДатчикТемпературы4DHT21);
	Если ТипЗнч(Ответ) = Тип("Структура") Тогда 
	    ТемператураДатчика4 = Ответ.Температура;
		ДатаТемператураДатчика4 = ТекущаяДата();
		ВлажностьДатчика4 = Ответ.Влажность;
		ДатаВлажностьДатчика4 = ТекущаяДата();
	КонецЕсли;
	// Тут будет температура уличного датчика
	
	// ПинРеле1НагревательОсновной
	Ответ = К.digitalRead(?( ТипЗнч(Оборудование.КонтроллерCOMNET) = Тип("СправочникСсылка.КонтроллерыCOM"), Оборудование.КонтроллерCOMNET.НомерCOMПорта, Оборудование.КонтроллерCOMNET.АдресПорт), ПинРеле1НагревательОсновной);
	Если ТипЗнч(Ответ) = Тип("Число") Тогда 
	    Реле1Вкл = Ответ=1;
		ДатаРеле1Вкл = ТекущаяДата();
	КонецЕсли;
	// ПинРеле2НагревательДополнительный
	Ответ = К.digitalRead(?( ТипЗнч(Оборудование.КонтроллерCOMNET) = Тип("СправочникСсылка.КонтроллерыCOM"), Оборудование.КонтроллерCOMNET.НомерCOMПорта, Оборудование.КонтроллерCOMNET.АдресПорт), ПинРеле2НагревательДополнительный);
	Если ТипЗнч(Ответ) = Тип("Число") Тогда 
	    Реле2Вкл = Ответ=1;
		ДатаРеле2Вкл = ТекущаяДата();
	КонецЕсли;
	// ПинРеле3НагревательАКБ
	Ответ = К.digitalRead(?( ТипЗнч(Оборудование.КонтроллерCOMNET) = Тип("СправочникСсылка.КонтроллерыCOM"), Оборудование.КонтроллерCOMNET.НомерCOMПорта, Оборудование.КонтроллерCOMNET.АдресПорт), ПинРеле3НагревательАКБ);
	Если ТипЗнч(Ответ) = Тип("Число") Тогда 
	    Реле3Вкл = Ответ=1;
		ДатаРеле3Вкл = ТекущаяДата();
	КонецЕсли;
	// ПинРеле4Свет
	Ответ = К.digitalRead(?( ТипЗнч(Оборудование.КонтроллерCOMNET) = Тип("СправочникСсылка.КонтроллерыCOM"), Оборудование.КонтроллерCOMNET.НомерCOMПорта, Оборудование.КонтроллерCOMNET.АдресПорт), ПинРеле4Свет);
	Если ТипЗнч(Ответ) = Тип("Число") Тогда 
	    Реле4Вкл = Ответ=1;
		ДатаРеле4Вкл = ТекущаяДата();
	КонецЕсли;
	
КонецПроцедуры
Функция ОпределитьТемпературуПоСопротивлению(Сопротивление)
	
	СоответствиеСопротивленияТемпературыТерморезитораMF52.Сортировать("Сопротивление");
	
	ВсегоСтрок = СоответствиеСопротивленияТемпературыТерморезитораMF52.Количество();

	НижГраница = 1;
	ВерхГрачница = ВсегоСтрок; 
	
	Пока ВерхГрачница - НижГраница > 1 Цикл	
		ТекСтрока = Окр((ВерхГрачница + НижГраница)/2);
		Если СоответствиеСопротивленияТемпературыТерморезитораMF52[ТекСтрока-1].Сопротивление > Сопротивление Тогда 
			ВерхГрачница = ТекСтрока;
		Иначе
			НижГраница = ТекСтрока;
		КонецЕсли;		
	КонецЦикла;
	
	Темература = СоответствиеСопротивленияТемпературыТерморезитораMF52[ВерхГрачница-1].Температура;
 
	
	Возврат Темература;
	
КонецФункции
Функция УстановитьСостоянияРеле()
	
	Ответ1 = К._pinModeOUTPUT_digitalWrite(?( ТипЗнч(Оборудование.КонтроллерCOMNET) = Тип("СправочникСсылка.КонтроллерыCOM"), Оборудование.КонтроллерCOMNET.НомерCOMПорта, Оборудование.КонтроллерCOMNET.АдресПорт) ,ПинРеле1НагревательОсновной, ?(Реле1Вкл, 1, 0));	
	Ответ2 = К._pinModeOUTPUT_digitalWrite(?( ТипЗнч(Оборудование.КонтроллерCOMNET) = Тип("СправочникСсылка.КонтроллерыCOM"), Оборудование.КонтроллерCOMNET.НомерCOMПорта, Оборудование.КонтроллерCOMNET.АдресПорт) ,ПинРеле2НагревательДополнительный, ?(Реле2Вкл, 1, 0));		
	Ответ3 = К._pinModeOUTPUT_digitalWrite(?( ТипЗнч(Оборудование.КонтроллерCOMNET) = Тип("СправочникСсылка.КонтроллерыCOM"), Оборудование.КонтроллерCOMNET.НомерCOMПорта, Оборудование.КонтроллерCOMNET.АдресПорт) ,ПинРеле3НагревательАКБ, ?(Реле3Вкл, 1, 0));	
	Ответ4 = К._pinModeOUTPUT_digitalWrite(?( ТипЗнч(Оборудование.КонтроллерCOMNET) = Тип("СправочникСсылка.КонтроллерыCOM"), Оборудование.КонтроллерCOMNET.НомерCOMПорта, Оборудование.КонтроллерCOMNET.АдресПорт) ,ПинРеле4Свет, ?(Реле4Вкл, 1, 0));	
	
	Ответ = Ответ1 И Ответ2 И Ответ3 И Ответ4;
	                
	Возврат Ответ; 
	
КонецФункции


Функция ЗаполнитьПины() Экспорт
	
	СообщениеСНенайденнымиПинами = "";
	
	//Реле
	СтрокаСНастройкой = Оборудование.Пины.Найти("ПинРеле1НагревательОсновной", "Наименование");
	Если СтрокаСНастройкой = Неопределено Тогда 
		СообщениеСНенайденнымиПинами = СообщениеСНенайденнымиПинами + "Не задан ПИН для ""ПинРеле1НагревательОсновной""; ";
	Иначе
		ПинРеле1НагревательОсновной = СтрокаСНастройкой.НомерПина;
	КонецЕсли;
	СтрокаСНастройкой = Оборудование.Пины.Найти("ПинРеле2НагревательДополнительный", "Наименование");
	Если СтрокаСНастройкой = Неопределено Тогда 
		СообщениеСНенайденнымиПинами = СообщениеСНенайденнымиПинами + "Не задан ПИН для ""ПинРеле2НагревательДополнительный""; ";
	Иначе
		ПинРеле2НагревательДополнительный = СтрокаСНастройкой.НомерПина;
	КонецЕсли;
	СтрокаСНастройкой = Оборудование.Пины.Найти("ПинРеле3НагревательАКБ", "Наименование");
	Если СтрокаСНастройкой = Неопределено Тогда 
		СообщениеСНенайденнымиПинами = СообщениеСНенайденнымиПинами + "Не задан ПИН для ""ПинРеле3НагревательАКБ""; ";
	Иначе
		ПинРеле3НагревательАКБ = СтрокаСНастройкой.НомерПина;
	КонецЕсли;
	СтрокаСНастройкой = Оборудование.Пины.Найти("ПинРеле4Свет", "Наименование");
	Если СтрокаСНастройкой = Неопределено Тогда 
		СообщениеСНенайденнымиПинами = СообщениеСНенайденнымиПинами + "Не задан ПИН для ""ПинРеле4Свет""; ";
	Иначе
		ПинРеле4Свет = СтрокаСНастройкой.НомерПина;
	КонецЕсли;
	
	//Датчики
	СтрокаСНастройкой = Оборудование.Пины.Найти("ПинДатчикТемпературы1MF52", "Наименование");
	Если СтрокаСНастройкой = Неопределено Тогда 
		СообщениеСНенайденнымиПинами = СообщениеСНенайденнымиПинами + "Не задан ПИН для ""ПинДатчикТемпературы1MF52""; ";
	Иначе
		ПинДатчикТемпературы1MF52 = СтрокаСНастройкой.НомерПина;
	КонецЕсли;
	СтрокаСНастройкой = Оборудование.Пины.Найти("ПинДатчикТемпературы2MF52", "Наименование");
	Если СтрокаСНастройкой = Неопределено Тогда 
		СообщениеСНенайденнымиПинами = СообщениеСНенайденнымиПинами + "Не задан ПИН для ""ПинДатчикТемпературы2MF52""; ";
	Иначе
		ПинДатчикТемпературы2MF52 = СтрокаСНастройкой.НомерПина;
	КонецЕсли;
	СтрокаСНастройкой = Оборудование.Пины.Найти("ПинДатчикТемпературы3MF52", "Наименование");
	Если СтрокаСНастройкой = Неопределено Тогда 
		СообщениеСНенайденнымиПинами = СообщениеСНенайденнымиПинами + "Не задан ПИН для ""ПинДатчикТемпературы3MF52""; ";
	Иначе
		ПинДатчикТемпературы3MF52 = СтрокаСНастройкой.НомерПина;
	КонецЕсли;
	СтрокаСНастройкой = Оборудование.Пины.Найти("ПинДатчикТемпературы4DHT21", "Наименование");
	Если СтрокаСНастройкой = Неопределено Тогда 
		СообщениеСНенайденнымиПинами = СообщениеСНенайденнымиПинами + "Не задан ПИН для ""ПинДатчикТемпературы4DHT21""; ";
	Иначе
		ПинДатчикТемпературы4DHT21 = СтрокаСНастройкой.НомерПина;
	КонецЕсли;

	Возврат СообщениеСНенайденнымиПинами;
	
КонецФункции
Функция  ЗаполнитьНастройки() Экспорт
	
	СообщениеСНенайденнымиНастройками = "";
	
	// Настройки в реквизитах
	СтрокаСТабСНастройкамиРеквизитов = Оборудование.Настройки.Найти("Реквизиты",  "Наименование");
	Если СтрокаСТабСНастройкамиРеквизитов = Неопределено Тогда 
		СообщениеСНенайденнымиНастройками = СообщениеСНенайденнымиНастройками + "Не заполнена настройка для реквизитов (В справочнике оборудование); ";
	Иначе
		ТабСНастройкамиРеквизитов = СтрокаСТабСНастройкамиРеквизитов.Настройка.ТаблицаНастроек;
		
		СтрокаСПараметром = ТабСНастройкамиРеквизитов.Найти("НастройкаАктивнаАвтоматикаОсновногоОбогревателя", "Параметр");
		Если СтрокаСПараметром = Неопределено Тогда 
			СообщениеСНенайденнымиНастройками = СообщениеСНенайденнымиНастройками + "Не указан параметр ""НастройкаАктивнаАвтоматикаОсновногоОбогревателя""; ";
		Иначе
			НастройкаАктивнаАвтоматикаОсновногоОбогревателя = СтрокаСПараметром.Значение;
		КонецЕсли;

		СтрокаСПараметром = ТабСНастройкамиРеквизитов.Найти("НастройкаМинТемператураОсновногоОбогревателя", "Параметр");
		Если СтрокаСПараметром = Неопределено Тогда 
			СообщениеСНенайденнымиНастройками = СообщениеСНенайденнымиНастройками + "Не указан параметр ""НастройкаМинТемператураОсновногоОбогревателя""; ";
		Иначе
			НастройкаМинТемператураОсновногоОбогревателя = СтрокаСПараметром.Значение;
		КонецЕсли;
		
		СтрокаСПараметром = ТабСНастройкамиРеквизитов.Найти("НастройкаМаксТемператураОсновногоОбогревателя", "Параметр");
		Если СтрокаСПараметром = Неопределено Тогда 
			СообщениеСНенайденнымиНастройками = СообщениеСНенайденнымиНастройками + "Не указан параметр ""НастройкаМаксТемператураОсновногоОбогревателя""; ";
		Иначе
			НастройкаМаксТемператураОсновногоОбогревателя = СтрокаСПараметром.Значение;
		КонецЕсли;
		
		СтрокаСПараметром = ТабСНастройкамиРеквизитов.Найти("НастройкаАктивнаАвтоматикаАКБОбогревателя", "Параметр");
		Если СтрокаСПараметром = Неопределено Тогда 
			СообщениеСНенайденнымиНастройками = СообщениеСНенайденнымиНастройками + "Не указан параметр ""НастройкаАктивнаАвтоматикаАКБОбогревателя""; ";
		Иначе
			НастройкаАктивнаАвтоматикаАКБОбогревателя = СтрокаСПараметром.Значение;
		КонецЕсли;

		СтрокаСПараметром = ТабСНастройкамиРеквизитов.Найти("НастройкаМинТемператураАКБОбогревателя", "Параметр");
		Если СтрокаСПараметром = Неопределено Тогда 
			СообщениеСНенайденнымиНастройками = СообщениеСНенайденнымиНастройками + "Не указан параметр ""НастройкаМинТемператураАКБОбогревателя""; ";
		Иначе
			НастройкаМинТемператураАКБОбогревателя = СтрокаСПараметром.Значение;
		КонецЕсли;
		
		СтрокаСПараметром = ТабСНастройкамиРеквизитов.Найти("НастройкаМаксТемператураАКБОбогревателя", "Параметр");
		Если СтрокаСПараметром = Неопределено Тогда 
			СообщениеСНенайденнымиНастройками = СообщениеСНенайденнымиНастройками + "Не указан параметр ""НастройкаМаксТемператураАКБОбогревателя""; ";
		Иначе
			НастройкаМаксТемператураАКБОбогревателя = СтрокаСПараметром.Значение;
		КонецЕсли;

	КонецЕсли;
	
	// Настройки СоответствиеСопротивленияТемпературыТерморезитораMF52-103/3435
	СтрокаСТабСоответствиеСопротивленияТемпературыТерморезитораMF52 = Оборудование.Настройки.Найти("СоответствиеСопротивленияТемпературыТерморезитораMF52-103/3435",  "Наименование");
	Если СтрокаСТабСоответствиеСопротивленияТемпературыТерморезитораMF52 = Неопределено Тогда 
		СообщениеСНенайденнымиНастройками = СообщениеСНенайденнымиНастройками + "Не заполнена настройка ""СоответствиеСопротивленияТемпературыТерморезитораMF52-103/3435"" (В справочнике оборудование); ";
	Иначе
		ТабСоответствиеСопротивленияТемпературыТерморезитораMF52 = СтрокаСТабСоответствиеСопротивленияТемпературыТерморезитораMF52.Настройка.ТаблицаНастроек;
		СоответствиеСопротивленияТемпературыТерморезитораMF52.Очистить();
		Для Каждого Строка Из ТабСоответствиеСопротивленияТемпературыТерморезитораMF52 Цикл
			нСтрока = СоответствиеСопротивленияТемпературыТерморезитораMF52.Добавить();	
			нСтрока.Сопротивление = Строка.Параметр;
			нСтрока.Температура = Строка.Значение;
		КонецЦикла;	
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
	
	//ТемператураДатчика1
	Менеджер = РегистрыСведений.ТекущиеДанныеОборудования.СоздатьМенеджерЗаписи();
	Менеджер.Оборудование = Оборудование;
	Менеджер.ОбъектДанных = "ТемператураДатчика1";
	Менеджер.Данные = ТемператураДатчика1;
	Менеджер.Дата = ТекущаяДата();
	Менеджер.Записать(Истина);	
	
	//ТемператураДатчика2
	Менеджер = РегистрыСведений.ТекущиеДанныеОборудования.СоздатьМенеджерЗаписи();
	Менеджер.Оборудование = Оборудование;
	Менеджер.ОбъектДанных = "ТемператураДатчика2";
	Менеджер.Данные = ТемператураДатчика2;
	Менеджер.Дата = ТекущаяДата();
	Менеджер.Записать(Истина);
	
	//ТемператураДатчика3
	Менеджер = РегистрыСведений.ТекущиеДанныеОборудования.СоздатьМенеджерЗаписи();
	Менеджер.Оборудование = Оборудование;
	Менеджер.ОбъектДанных = "ТемператураДатчика3";
	Менеджер.Данные = ТемператураДатчика3;
	Менеджер.Дата = ТекущаяДата();
	Менеджер.Записать(Истина);

	//ТемператураДатчика4
	Менеджер = РегистрыСведений.ТекущиеДанныеОборудования.СоздатьМенеджерЗаписи();
	Менеджер.Оборудование = Оборудование;
	Менеджер.ОбъектДанных = "ТемператураДатчика4";
	Менеджер.Данные = ТемператураДатчика4;
	Менеджер.Дата = ТекущаяДата();
	Менеджер.Записать(Истина);

	//ВлажностьДатчика4
	Менеджер = РегистрыСведений.ТекущиеДанныеОборудования.СоздатьМенеджерЗаписи();
	Менеджер.Оборудование = Оборудование;
	Менеджер.ОбъектДанных = "ВлажностьДатчика4";
	Менеджер.Данные = ВлажностьДатчика4;
	Менеджер.Дата = ТекущаяДата();
	Менеджер.Записать(Истина);

	//Состояние Реле1
	Менеджер = РегистрыСведений.ТекущиеДанныеОборудования.СоздатьМенеджерЗаписи();
	Менеджер.Оборудование = Оборудование;
	Менеджер.ОбъектДанных = "Реле1Вкл";
	Менеджер.Данные = Реле1Вкл;
	Менеджер.Дата = ТекущаяДата();
	Менеджер.Записать(Истина);

	//Состояние Реле2
	Менеджер = РегистрыСведений.ТекущиеДанныеОборудования.СоздатьМенеджерЗаписи();
	Менеджер.Оборудование = Оборудование;
	Менеджер.ОбъектДанных = "Реле2Вкл";
	Менеджер.Данные = Реле2Вкл;
	Менеджер.Дата = ТекущаяДата();
	Менеджер.Записать(Истина);
	
	//Состояние Реле3
	Менеджер = РегистрыСведений.ТекущиеДанныеОборудования.СоздатьМенеджерЗаписи();
	Менеджер.Оборудование = Оборудование;
	Менеджер.ОбъектДанных = "Реле3Вкл";
	Менеджер.Данные = Реле3Вкл;
	Менеджер.Дата = ТекущаяДата();
	Менеджер.Записать(Истина);

	//Состояние Реле4
	Менеджер = РегистрыСведений.ТекущиеДанныеОборудования.СоздатьМенеджерЗаписи();
	Менеджер.Оборудование = Оборудование;
	Менеджер.ОбъектДанных = "Реле4Вкл";
	Менеджер.Данные = Реле4Вкл;
	Менеджер.Дата = ТекущаяДата();
	Менеджер.Записать(Истина);

КонецПроцедуры
