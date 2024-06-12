import math

# Hàm tính toán giá trị a và b từ hai điểm trên đường cong đặc trưng
def calculate_a_b(x1, y1, x2, y2):
    # Chuyển đổi logarit
    log_x1 = math.log10(x1)
    log_y1 = math.log10(y1)
    log_x2 = math.log10(x2)
    log_y2 = math.log10(y2)

    # Tính toán b (slope)
    b = (log_y2 - log_y1) / (log_x2 - log_x1)

    # Tính toán log(a)
    log_a = log_y1 - b * log_x1

    # Chuyển đổi log(a) thành a
    a = math.pow(10, log_a)

    return a, b

# Các giá trị từ LPGCurve
# Điểm 1: (200, 0.21), Điểm 2: (10000, -0.47)
x1 = 200
y1 = math.pow(10, 0.21)
x2 = 10000
y2 = math.pow(10, -0.47)

a, b = calculate_a_b(x1, y1, x2, y2)

print("a =", a)
print("b =", b)
