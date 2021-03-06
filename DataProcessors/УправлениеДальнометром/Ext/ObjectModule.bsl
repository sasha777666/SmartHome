﻿
//Дальнометр должен быть подключен к цифровым пинам

Процедура ПроцессДляСервераЧтениеРасстоянияУЗДальнометром(Процесс = "") Экспорт
	
	ИнициирующийПроцесс = Процесс;
	
	ИнициализацияЧтениеРасстоянияУЗДальнометром();
	ДатаПолученияРасстояния = '00010101';
	ПолучитьРасстояниеУЗДальнометром();
	
	Если ДатаПолученияРасстояния <> '00010101' Тогда 
		ЗаписатьТекущееДанные();	
	КонецЕсли;
	
КонецПроцедуры

//////
Функция ЗаполнитьПиныУЗДальнометром() 
	
	СообщениеСНенайденнымиПинами = "";
	
	СтрокаСНастройкой = Оборудование.Пины.Найти("Trig", "Наименование");
	Если СтрокаСНастройкой = Неопределено Тогда 
		СообщениеСНенайденнымиПинами = СообщениеСНенайденнымиПинами + "Не задан ПИН для ""Trig""; ";
	Иначе
		НомерПинаTrig = СтрокаСНастройкой.НомерПина;
	КонецЕсли;
	
	СтрокаСНастройкой = Оборудование.Пины.Найти("Echo", "Наименование");
	Если СтрокаСНастройкой = Неопределено Тогда 
		СообщениеСНенайденнымиПинами = СообщениеСНенайденнымиПинами + "Не задан ПИН для ""Echo""; ";
	Иначе
		НомерПинаEcho = СтрокаСНастройкой.НомерПина;
	КонецЕсли;
	
	Возврат СообщениеСНенайденнымиПинами;
	
КонецФункции

Процедура ИнициализацияЧтениеРасстоянияУЗДальнометром()
		
	Ответ = ЗаполнитьПиныУЗДальнометром();
	Если ЗначениеЗаполнено(Ответ) Тогда 
		Сообщения = Сообщения + Символы.ПС + ТекущаяДата() + " " + Ответ;
	КонецЕсли;
	
КонецПроцедуры
Процедура ПолучитьРасстояниеУЗДальнометром()
	
	Ответ = К.UzDistance(Оборудование, НомерПинаTrig, НомерПинаEcho); 

	Если ТипЗнч(Ответ) = Тип("Число") Тогда 
		Расстояние = Ответ;
		ДатаПолученияРасстояния = ТекущаяДата();
	Иначе
		Сообщения = Сообщения + Символы.ПС + ТекущаяДата() + "Не удалось получить расстояние";
	КонецЕсли;	
	
КонецПроцедуры
/////	

Процедура ЗаписатьТекущееДанные()
	
	ОбщегоНазначения.ЗаписатьДанныеОборудования(Оборудование, "Расстояние", Расстояние, ДатаПолученияРасстояния); 
	
КонецПроцедуры

