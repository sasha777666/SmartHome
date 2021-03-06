﻿
Функция ОбработатьСобытие(ЭлементСправочника, ПараметрыЗапроса) Экспорт
	//Параметры - соответствие из запроса	
	
	Ответ = "";
	
	
	Если ЭлементСправочника.Активно Тогда  
		ГруппаУсловийВыполняется = Истина;
		Если ЗначениеЗаполнено(ЭлементСправочника.ГруппаУсловий) Тогда 
			ГруппаУсловийВыполняется = СерверПривилегированный.ПроверкаГруппыУсловий(ЭлементСправочника.ГруппаУсловий);
		КонецЕсли;
		Если ГруппаУсловийВыполняется Тогда 
			Для Каждого Строка Из ЭлементСправочника.Действия Цикл
				ГруппаУсловийДействияВыполняется = Истина; 
				Если ЗначениеЗаполнено(Строка.ГруппаУсловий) Тогда
					ГруппаУсловийДействияВыполняется = СерверПривилегированный.ПроверкаГруппыУсловий(Строка.ГруппаУсловий);
	            КонецЕсли;
				Если ГруппаУсловийДействияВыполняется Тогда
					Если ТипЗнч(Строка.Действие) = Тип("СправочникСсылка.Действия") Тогда // Это действие
						МассивСДействием = Новый Массив();
						МассивСДействием.Добавить(Строка.Действие);
						Если Строка.ОжидатьЗавершения Тогда		
							Справочники.Действия.ВыполнитьДействия(МассивСДействием);	
						Иначе
							МассивСПараметрамиДляДействий = Новый Массив();
							МассивСПараметрамиДляДействий.Добавить(МассивСДействием);
							ОбщегоНазначения.ВыполнитьПроцедуруФункциюВФонеНаСервере("Справочники.Действия.ВыполнитьДействия", МассивСПараметрамиДляДействий);	
						КонецЕсли;					
					ИначеЕсли ТипЗнч(Строка.Действие) = Тип("СправочникСсылка.ГруппыДействий") Тогда // Это группа действий
						Если Строка.ОжидатьЗавершения Тогда		
							Справочники.ГруппыДействий.ВыполнитьГруппуДействий(Строка.Действие);	
						Иначе
							МассивСПараметрамиДляГруппыДействий = Новый Массив();
							МассивСПараметрамиДляГруппыДействий.Добавить(Строка.Действие);
							ОбщегоНазначения.ВыполнитьПроцедуруФункциюВФонеНаСервере("Справочники.ГруппыДействий.ВыполнитьГруппуДействий", МассивСПараметрамиДляГруппыДействий);	
						КонецЕсли;		
					КонецЕсли;				
				КонецЕсли;		
			КонецЦикла;
			Если ЭлементСправочника.ВозвращатьОтвет Тогда
				ТекстПолученияПеременных = "";
				МассивЗначенийПеременных = Новый Массив();
				н = -1;
				Для Каждого СтрокаПеременной Из ЭлементСправочника.ПеременныеДляПроцедуры Цикл
					н = н + 1;
					ТекстПолученияПеременных = ТекстПолученияПеременных + СтрокаПеременной.ИмяПеременной + " = "
					+ "МассивЗначенийПеременных[" + н + "];" + Символы.ПС;
					МассивЗначенийПеременных.Добавить(СтрокаПеременной.Значение);		
				КонецЦикла;
				КодПроверкиУсловия = ТекстПолученияПеременных +	ЭлементСправочника.КодФормированияОтвета;
				Попытка 
					Выполнить(КодПроверкиУсловия);
				Исключение
					ОписаниеОшибки = "Ошибка при выполнении кода формирования ответа для элемента HTTPName = " + ЭлементСправочника.HTTPName + ". Описание ошибки = " + ОписаниеОшибки(); 
					ЗаписьВЖурналОшибок("Справочники.СобытияHTTP.МодульМенеджера", "ОбработатьСобытие", ОписаниеОшибки);
				КонецПопытки;
			КонецЕсли;
		КонецЕсли;	
	КонецЕсли;
	
	
	Возврат Ответ;
	
КонецФункции
