﻿
// НайтиПодходящийПрокси - находит рабочий прокси сервер для указанного протокола 
// Возвращает: Ссылку на справочник ПроксиСервера (Пустая ссылка если ничего не найдено)
// Параметры:
// Протокол - Строка(Необязательный) - Имя нужного протокола(Если не задано, то будет подбираться универсальный прокси, для всех протоколов) 
Функция НайтиДанныеПодходящегоПрокси(Протокол = "Все") Экспорт
	
	Запрос = Новый Запрос();
	Запрос.Текст = "ВЫБРАТЬ ПЕРВЫЕ 1
	               |	ПроксиСервера.Ссылка
	               |ИЗ
	               |	Справочник.ПроксиСервера КАК ПроксиСервера
	               |ГДЕ
	               |	ПроксиСервера.Актуален
	               |	И ПроксиСервера.МожноИспользовать
	               |	И ПроксиСервера.Протокол В(&Протоколы)
	               |
	               |УПОРЯДОЧИТЬ ПО
	               |	ПроксиСервера.ПриоритетИспользования УБЫВ";
	Протоколы = Новый Массив();
	Протоколы.Добавить("Все");                             
	Протоколы.Добавить(Протокол);
	Запрос.УстановитьПараметр("Протоколы", Протоколы);
	Выборка = Запрос.Выполнить().Выбрать();
	
	Если Выборка.Следующий() Тогда
		ДанныеПрокси = Выборка.Ссылка;
	Иначе
		ДанныеПрокси = Справочники.ПроксиСервера.ПустаяСсылка();
	КонецЕсли;
	
	Возврат ДанныеПрокси;	
	
КонецФункции

// ПолучитьПодходящийПрокси - находит рабочий прокси сервер для указанного протокола 
// Возвращает: ИнтернетПрокси(), Неопределено
// Параметры:
// Протокол - Строка(Необязательный) - Имя нужного протокола (Например http, https)) 
Функция ПолучитьПодходящийПрокси(Протокол) Экспорт

	ДанныеПрокси = НайтиДанныеПодходящегоПрокси(Протокол);
	Если ЗначениеЗаполнено(ДанныеПрокси) Тогда
		Прокси = Новый ИнтернетПрокси();
		Прокси.Пользователь = ДанныеПрокси.Пользователь;
		Прокси.Пароль = ДанныеПрокси.Пароль;
		Прокси.Установить(Протокол, ДанныеПрокси.АдресПроксиСервера, ДанныеПрокси.ПортПроксиСервера);
	Иначе
		Прокси = Неопределено;
	КонецЕсли;

	Возврат Прокси;
	
КонецФункции


Процедура ИзменитьПриоритетПрокси(ПроксиСервер, Дельта) Экспорт
	
	ТекущийПриоритетПрокси = ПроксиСервер.ПриоритетИспользования;
	НовыйПриоритетПрокси = ТекущийПриоритетПрокси + Дельта;
	Если НовыйПриоритетПрокси <= 0 Тогда //Снимаем галку актуален
		ОбъектПроксиСервер = ПроксиСервер.ПолучитьОбъект();
	    ОбъектПроксиСервер.ПриоритетИспользования = 0;
		ОбъектПроксиСервер.Актуален = Ложь;
		ОбъектПроксиСервер.Записать();
	Иначе
		Если НовыйПриоритетПрокси > 999 Тогда // Приоритет может быть в диапазоне 0 - 999 
			НовыйПриоритетПрокси = 999;	
		КонецЕсли;	
		ОбъектПроксиСервер = ПроксиСервер.ПолучитьОбъект();
		ОбъектПроксиСервер.ПриоритетИспользования = НовыйПриоритетПрокси;
		ОбъектПроксиСервер.Записать();
	КонецЕсли;
	
КонецПроцедуры



