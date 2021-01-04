from datetime import datetime


def to_start_end_day(date_val):
    start_date = datetime.strptime(f'{date_val} 00:00:00', "%Y-%m-%d %H:%M:%S")
    end_date = datetime.strptime(f'{date_val} 23:59:59', "%Y-%m-%d %H:%M:%S")
    return start_date, end_date


def updateDict(val_data):
    merged = dict()
    merged.update(val_data)
    merged['date_time'] = val_data['date_time'].strftime("%Y-%m-%d %H:%M:%S")
    return merged
