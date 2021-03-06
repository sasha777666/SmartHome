﻿
Функция ОбработатьТекстПоЧёткомуСовпадениюВсегоСообщенияСШаблоном(СсылкаДокВхСообщение) Экспорт
	
	РезультатОбработки = Ложь;
	
	ПозицияАдресаБота = СтрНайти(СсылкаДокВхСообщение.Текст, ТелеграмМодуль.ПолучитьАдресТелеграмБота());
	Если ПозицияАдресаБота > 0 Тогда
		ТекстСообщения = Лев(СсылкаДокВхСообщение.Текст, ПозицияАдресаБота-1);
	Иначе
		ТекстСообщения = СсылкаДокВхСообщение.Текст;
	КонецЕсли;

	Шаблон = Справочники.ТелеграмОбработкаЧёткиеШаблоныСообщений.НайтиПоРеквизиту("Шаблон", ТекстСообщения); 
	Если ЗначениеЗаполнено(Шаблон) И Шаблон.Активность Тогда 
		
		Если СсылкаДокВхСообщение.ТелеграмКонтакт.ДоступМаксимальныйУровеньОбработчика >= Шаблон.ДоступУровеньОбработчика Тогда //Выполняем 
			Если ЗначениеЗаполнено(Шаблон.Действие) Тогда // Выполняем
				Если ТипЗнч(Шаблон.Действие) = Тип("СправочникСсылка.Действия") Тогда 
					МассивСДействием = Новый Массив();
					МассивСДействием.Добавить(Шаблон.Действие);
				    Справочники.Действия.ВыполнитьДействия(МассивСДействием);
				ИначеЕсли ТипЗнч(Шаблон.Действие) = Тип("СправочникСсылка.ГруппыДействий") Тогда 
					Справочники.ГруппыДействий.ВыполнитьГруппуДействий(Шаблон.Действие);
				КонецЕсли;
			КонецЕсли;
			
			ОтветТекст = Шаблон.ФиксированныйТекстовыйОтвет;
			
			Если Шаблон.ВыполнятьКодПослеСовершенияДействия Тогда 
				Ответ = "";
				
				ТекстПолученияПеременных = "";
				МассивЗначенийПеременных = Новый Массив();
				н = -1;
				Для Каждого СтрокаПеременной Из Шаблон.ПеременныеДляПроцедуры Цикл
					н = н + 1;
					ТекстПолученияПеременных = ТекстПолученияПеременных + СтрокаПеременной.ИмяПеременной + " = "
					+ "МассивЗначенийПеременных[" + н + "];" + Символы.ПС;
					МассивЗначенийПеременных.Добавить(СтрокаПеременной.Значение);		
				КонецЦикла;
				пВыполняемыйКодПослеСовершенияДействия = ТекстПолученияПеременных +	Шаблон.ВыполняемыйКодПослеСовершенияДействия;
				Попытка
					Ответ = ВыполнитьКодШаблонаИзолированно(СсылкаДокВхСообщение, пВыполняемыйКодПослеСовершенияДействия);	
				Исключение
					ОписаниеОшибки = "Сбой при обработки шаблона после совершения действия. Шаблон: """ +  Шаблон.Шаблон + """. Описание ошибки: " + ОписаниеОшибки();
					ЗаписьВЖурналОшибок("Справочники.ТелеграмОбработкаЧёткиеШаблоныСообщений.МодульМенеджера", "ОбработатьТекстПоЧёткомуСовпадениюВсегоСообщенияСШаблоном", ОписаниеОшибки);	
					Результат = Ложь;
				КонецПопытки;
	
				Если ЗначениеЗаполнено(Ответ) Тогда 
					ОтветТекст = ?(ЗначениеЗаполнено(ОтветТекст), ОтветТекст + Символы.ПС + Ответ, Ответ);
				КонецЕсли;
			КонецЕсли;
			
		Иначе // Если доступа нет то обработка по шаблоку не выполняется но сообщение считается обработанным, возвращаем уведомление
			ОтветТекст = "Нет прав на обработку чётким шаблоном """ + Шаблон.Шаблон + """";
		КонецЕсли;
		
		Если ЗначениеЗаполнено(ОтветТекст) Тогда
			СтруктураОтвета = Новый Структура();
			СтруктураОтвета.Вставить("ТелеграмКонтакт", СсылкаДокВхСообщение.ТелеграмКонтакт); 
			СтруктураОтвета.Вставить("Текст", ОтветТекст);
			
			ТелеграмМодуль.СоздатьИОтправитьДокСообщениеИсходящие(СтруктураОтвета);	
		КонецЕсли;
					          
		РезультатОбработки = Истина;	
	КонецЕсли;
		
	Возврат РезультатОбработки;	
	
КонецФункции

Функция ВыполнитьКодШаблонаИзолированно(СсылкаНаСообщение, ВыполняемыйКодПослеСовершенияДействия);
	
	СсылкаДокВхСообщение = СсылкаНаСообщение;
	пВыполняемыйКодПослеСовершенияДействия = ВыполняемыйКодПослеСовершенияДействия;
	Ответ = "";
	
	Выполнить(пВыполняемыйКодПослеСовершенияДействия);
	
	Возврат Ответ;
	
КонецФункции
