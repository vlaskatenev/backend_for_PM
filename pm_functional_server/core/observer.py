from __future__ import annotations
from abc import ABC, abstractmethod
from random import randrange
from typing import List


class Subject(ABC):
    """
    Интферфейс издателя объявляет набор методов для управлениями подписчиками.
    """

    @abstractmethod
    def attach(self, observer) -> None:
        """
        Присоединяет наблюдателя к издателю.
        """
        pass

    @abstractmethod
    def detach(self, observer) -> None:
        """
        Отсоединяет наблюдателя от издателя.
        """
        pass

    @abstractmethod
    def notify(self) -> None:
        """
        Уведомляет всех наблюдателей о событии.
        """
        pass


class ConcreteSubject(Subject):
    """
    Издатель владеет некоторым важным состоянием и оповещает наблюдателей о его
    изменениях.
    """

    _state: int = None
    """
    Для удобства в этой переменной хранится состояние Издателя, необходимое всем
    подписчикам.
    """

    _observers: List = []
    """
    Список подписчиков. В реальной жизни список подписчиков может храниться в
    более подробном виде (классифицируется по типу события и т.д.)
    """

    def attach(self, observer) -> None:
        self._observers.append(observer)
        print("Subject: Attached an observer.", self._observers)

    # здесь будет удаление подписки на объект и дальнейшая запись в БД об успешном окончании задания
    def detach(self, response_from_pc) -> None:
        temp_array = []
        for i in range(len(self._observers)):
            if response_from_pc['result_work']:
                if response_from_pc['id_install'] == self._observers[i]['id_install']:
                    temp_array.append(self._observers[i])
        for obj in temp_array:
            self._observers.remove(obj)


        print("Subject: Detached an observer.", self._observers)
    """
    Методы управления подпиской.
    """

    def notify(self, response_from_pc) -> None:
        """
        Запуск обновления в каждом подписчике перед отпиской.
        """

        print("Subject: Notifying observers...")
        for i in range(len(self._observers)):
            if response_from_pc['id_install'] == self._observers[i]['id_install']:
                self._observers[i]['result_work'] = response_from_pc['result_work']
            


