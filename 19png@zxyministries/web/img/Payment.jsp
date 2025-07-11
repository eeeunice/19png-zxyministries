<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <title>Payment Page</title>
    <link rel="icon" type="image/x-icon" href="img/Logo/logo4.png"> <!--this is an icon-->
    <link href="css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    <link rel="stylesheet" href="./css/Product_Customer.css">
    <style>
        body {
            background-color: #fff;
            font-family: Arial, sans-serif;
        }
        
        .payment-container {
            max-width: 800px;
            margin: 20px auto;
            padding: 30px;
            background: #fff;
            box-shadow: 0 2px 10px rgba(0,0,0,0.05);
            border-radius: 8px;
        }
        
        .payment-header {
            text-align: center;
            margin-bottom: 40px;
        }
        
        .payment-header h2 {
            color: #333;
            font-size: 28px;
            margin-bottom: 10px;
            font-weight: 600;
        }
        
        .payment-header p {
            color: #666;
            font-size: 16px;
        }
        
        .form-group {
            margin-bottom: 25px;
        }
        
        .form-label {
            color: #333;
            font-weight: 500;
            margin-bottom: 10px;
            display: block;
            font-size: 15px;
        }
        
        .form-control {
            border: 1px solid #e0e0e0;
            border-radius: 6px;
            padding: 12px;
            width: 100%;
            font-size: 14px;
            transition: border-color 0.3s;
        }
        
        .form-control:focus {
            border-color: #008000;
            outline: none;
            box-shadow: 0 0 0 2px rgba(128,0,128,0.1);
        }
        
        select.form-control {
            appearance: none;
            background-image: url("data:image/svg+xml;charset=UTF-8,%3csvg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 24 24' fill='none' stroke='currentColor' stroke-width='2' stroke-linecap='round' stroke-linejoin='round'%3e%3cpolyline points='6 9 12 15 18 9'%3e%3c/polyline%3e%3c/svg%3e");
            background-repeat: no-repeat;
            background-position: right 12px center;
            background-size: 16px;
            padding-right: 40px;
        }
        
        .amount-section {
            background-color: #f8f9fa;
            padding: 25px;
            margin: 30px 0;
            border-radius: 8px;
            border: 1px solid #eee;
        }
        
        .amount-row {
            margin-bottom: 15px;
            display: flex;
            justify-content: space-between;
            align-items: center;
        }
        
        .amount-row:last-child {
            margin-bottom: 0;
            padding-top: 15px;
            border-top: 1px solid #e0e0e0;
        }
        
        .amount-label {
            color: #333;
            font-weight: 500;
            font-size: 15px;
        }
        
        .amount-value {
            width: 60%;
        }
        
        .final-total {
            font-size: 20px;
            color: #008000;
            font-weight: 600;
        }
        
        .btn-back {
            color: #008000;
            text-decoration: none;
            font-weight: 500;
            font-size: 15px;
            position: relative;
        }
        
        .btn-back:hover {
            color: #660066;
            text-decoration: underline;
        }
        
        .btn-confirm {
            background-color: #800080;
            color: white;
            border: none;
            padding: 12px 30px;
            border-radius: 6px;
            font-weight: 500;
            font-size: 15px;
            transition: all 0.3s;
        }
        
        .btn-confirm:hover {
            background-color: #660066;
            transform: translateY(-1px);
            box-shadow: 0 2px 5px rgba(128,0,128,0.2);
        }
        
        .btn-confirm:active {
            transform: translateY(0);
        }
        
        /* 添加支付方式样式 */
        .payment-methods {
            display: flex;
            flex-wrap: wrap;
            gap: 15px;
            margin-bottom: 25px;
        }
        
        .payment-method-option {
            flex: 1;
            min-width: 120px;
            border: 1px solid #e0e0e0;
            border-radius: 8px;
            padding: 15px;
            text-align: center;
            cursor: pointer;
            transition: all 0.3s;
        }
        
        .payment-method-option:hover {
            border-color: #008000;
            background-color: #f9f0f9;
        }
        
        .payment-method-option.selected {
            border-color: #008000;
            background-color: #f9f0f9;
            box-shadow: 0 0 0 2px rgba(128,0,128,0.2);
        }
        
        .payment-method-option i {
            font-size: 24px;
            margin-bottom: 10px;
            color: #008000;
        }
        
        .payment-method-option span {
            display: block;
            font-size: 14px;
            color: #333;
        }
        
        .payment-details {
            margin-top: 25px;
            display: none;
        }
        
        .payment-details.active {
            display: block;
        }
    </style>
</head>
<body>
    <header>
        <div class="header-content">
            <a href="Product_Customer.jsp">
              <img src="img/Logo/logo2.png" width="280" height="190" alt="Logo"/>
            </a>
        </div>
    </header>
    
    <div class="container payment-container">
        <div class="payment-header">
            <h2>Payment Details</h2>
            <p>Please complete your payment information</p>
        </div>
        
        <form method="POST" action="Receipt.jsp" onsubmit="return validateForm();">
            <div class="form-group">
                <label class="form-label">Select Payment Method</label>
                <div class="payment-methods">
                    <div class="payment-method-option" data-method="CREDIT_CARD">
                        <i class="fas fa-credit-card"></i>
                        <span>Credit Card</span>
                    </div>
                    <div class="payment-method-option" data-method="DEBIT_CARD">
                        <i class="fas fa-credit-card"></i>
                        <span>Debit Card</span>
                    </div>
                    <div class="payment-method-option" data-method="ONLINE_BANKING">
                        <i class="fas fa-university"></i>
                        <span>Online Banking</span>
                    </div>
                    <div class="payment-method-option" data-method="E_WALLET">
                        <i class="fas fa-wallet"></i>
                        <span>E-Wallet</span>
                    </div>
                    <div class="payment-method-option" data-method="CASH">
                        <i class="fas fa-money-bill-wave"></i>
                        <span>Cash</span>
                    </div>
                </div>
                <input type="hidden" name="paymentMethod" id="paymentMethodInput" required>
            </div>
            
            <!-- Credit/Debit Card Payment Details -->
            <div id="cardPaymentDetails" class="payment-details">
                <div class="form-group">
                    <label class="form-label">Cardholder Name</label>
                    <input type="text" class="form-control" name="cardHolderName">
                </div>
                <div class="form-group">
                    <label class="form-label">Card Number</label>
                    <input type="text" class="form-control" name="cardNumber" placeholder="XXXX XXXX XXXX XXXX" maxlength="19">
                </div>
                <div class="row">
                    <div class="col-md-6">
                        <div class="form-group">
                            <label class="form-label">Expiry Date</label>
                            <input type="text" class="form-control" name="expiryDate" placeholder="MM/YY" maxlength="5">
                        </div>
                    </div>
                    <div class="col-md-6">
                        <div class="form-group">
                            <label class="form-label">CVV Security Code</label>
                            <input type="text" class="form-control" name="cvv" placeholder="XXX" maxlength="3">
                        </div>
                    </div>
                </div>
            </div>
            
            <!-- E-Wallet Payment Details -->
            <div id="eWalletPaymentDetails" class="payment-details">
                <div class="form-group">
                    <label class="form-label">E-Wallet Provider</label>
                    <select class="form-control" name="eWalletType">
                        <option value="">Select E-Wallet</option>
                        <option value="ALIPAY">Alipay</option>
                        <option value="WECHAT">WeChat Pay</option>
                        <option value="TOUCH_N_GO">Touch 'n Go</option>
                        <option value="BOOST">Boost</option>
                    </select>
                </div>
                <div class="form-group">
                    <label class="form-label">E-Wallet Account</label>
                    <input type="text" class="form-control" name="eWalletAccount">
                </div>
            </div>
            
            <!-- Online Banking Payment Details -->
            <div id="onlineBankingDetails" class="payment-details">
                <div class="form-group">
                    <label class="form-label">Select Bank</label>
                    <select class="form-control" name="bankName">
                        <option value="">Select Bank</option>
                        <option value="MAYBANK">Maybank</option>
                        <option value="CIMB">CIMB Bank</option>
                        <option value="PUBLIC_BANK">Public Bank</option>
                        <option value="RHB">RHB Bank</option>
                        <option value="HONG_LEONG">Hong Leong Bank</option>
                        <option value="AMBANK">AmBank</option>
                        <option value="BANK_RAKYAT">Bank Rakyat</option>
                        <option value="OCBC">OCBC Bank</option>
                        <option value="HSBC">HSBC Bank</option>
                    </select>
                </div>
                <div class="form-group">
                    <label class="form-label">Account Number</label>
                    <input type="text" class="form-control" name="bankAccountNumber">
                </div>
            </div>
            
            <!-- Cash Payment Details -->
            <div id="cashPaymentDetails" class="payment-details">
                <div class="form-group">
                    <label class="form-label">Cash Payment Option</label>
                    <div class="form-check">
                        <input class="form-check-input" type="radio" name="cashPaymentType" id="cashOnDelivery" value="CASH_ON_DELIVERY" checked>
                        <label class="form-check-label" for="cashOnDelivery">
                            Cash on Delivery
                        </label>
                        <p class="text-muted small">Pay with cash when your order is delivered to your doorstep.</p>
                    </div>
                    <div class="form-check">
                        <input class="form-check-input" type="radio" name="cashPaymentType" id="cashAtStore" value="CASH_AT_STORE">
                        <label class="form-check-label" for="cashAtStore">
                            Cash Payment at Physical Stores
                        </label>
                        <p class="text-muted small">Visit our physical store to make your payment and collect your order.</p>
                    </div>
                </div>
            </div>
            
            <div class="form-group">
                <label class="form-label">Shipping Address</label>
                <textarea class="form-control" name="shippingAddress" rows="3" required></textarea>
            </div>
            
            <div class="form-group">
                <label class="form-label">Contact Number</label>
                <input type="text" class="form-control" name="contactPhone" required>
            </div>

            <!-- 修改为折扣代码下拉选择 -->
            <div class="form-group discount-section">
                <label for="discountCode">Promo Code</label>
                <select class="form-control" id="discountCode" name="discountCode">
                    <option value="">-- Please Select Promo Code --</option>
                    <option value="SUMMER25">SUMMER25 (RM 25.00 Discount)</option>
                    <option value="WELCOME15">WELCOME15 (RM 15.00 Discount)</option>
                    <option value="HOLIDAY30">HOLIDAY30 (RM 30.00 Discount)</option>
                    <option value="FLASH50">FLASH50 (RM 50.00 Discount)</option>
                    <option value="BDAY20">BDAY20 (RM 20.00 Discount)</option>
                    <option value="SKINCARE10">SKINCARE10 (RM 10.00 Discount)</option>
                </select>
                <small id="discountMessage" class="form-text text-success"></small>
            </div>
            
            <!-- 添加隐藏字段存储折扣金额 -->
            <input type="hidden" id="discountAmount" name="discountAmount" value="0">
            
            <div class="amount-section">
                <div class="amount-row">
                    <label class="amount-label">Subtotal</label>
                    <div class="amount-value">
                        <input type="text" class="form-control" name="totalPrice" id="subtotal" value="RM ${requestScope.totalPrice}" readonly>
                    </div>
                </div>
                
                <div class="amount-row">
                    <label class="amount-label">Shipping Cost</label>
                    <div class="amount-value">
                        <input type="text" class="form-control" name="shippingCost" id="shipping" value="RM ${requestScope.shippingCost}" readonly>
                    </div>
                </div>
                
                <div class="amount-row">
                    <label class="amount-label">Sales Tax</label>
                    <div class="amount-value">
                        <input type="text" class="form-control" name="salesTax" id="tax" value="RM ${requestScope.salesTax}" readonly>
                    </div>
                </div>
                
                <!-- 添加折扣显示行 -->
                <div class="amount-row" id="discountRow" style="display: none; color: #008000;">
                    <label class="amount-label">Discount</label>
                    <div class="amount-value">
                        <input type="text" class="form-control" id="discountDisplay" style="color: #008000; font-weight: bold;" readonly>
                    </div>
                </div>
                
                <div class="amount-row">
                    <label class="amount-label">Final Total</label>
                    <div class="final-total" id="total">RM ${requestScope.finalTotal}</div>
                    <input type="hidden" id="finalTotal" name="finalTotal" value="RM ${requestScope.finalTotal}">
                </div>
            </div>

            <input type="hidden" name="orderId" value="${sessionScope.orderId}">
            
            <div class="d-flex justify-content-between align-items-center mt-4">
                <a href="ViewCartServlet" class="btn-back" style="color: #008000; text-decoration: none;">← Back to Cart</a>
                <button type="submit" class="btn-confirm" style="background-color: #027148; border:none; padding: 12px 30px; border-radius: 6px; font-weight: 500; font-size: 15px; color: white; cursor: pointer; transition: all 0.3s ease;">
                    Complete Payment
                </button>
            </div>
        </form>
    </div>

    
    <script>
        // 支付方式选择
        const paymentOptions = document.querySelectorAll('.payment-method-option');
        const paymentMethodInput = document.getElementById('paymentMethodInput');
        const cardPaymentDetails = document.getElementById('cardPaymentDetails');
        const eWalletPaymentDetails = document.getElementById('eWalletPaymentDetails');
        const onlineBankingDetails = document.getElementById('onlineBankingDetails');
        const cashPaymentDetails = document.getElementById('cashPaymentDetails');
        
        paymentOptions.forEach(option => {
            option.addEventListener('click', function() {
                // 移除所有选中状态
                paymentOptions.forEach(opt => opt.classList.remove('selected'));
                
                // 添加当前选中状态
                this.classList.add('selected');
                
                // 设置隐藏输入值
                const method = this.getAttribute('data-method');
                paymentMethodInput.value = method;
                
                // 显示相应的支付详情
                cardPaymentDetails.classList.remove('active');
                eWalletPaymentDetails.classList.remove('active');
                onlineBankingDetails.classList.remove('active');
                cashPaymentDetails.classList.remove('active');
                
                if (method === 'CREDIT_CARD' || method === 'DEBIT_CARD') {
                    cardPaymentDetails.classList.add('active');
                } else if (method === 'E_WALLET') {
                    eWalletPaymentDetails.classList.add('active');
                } else if (method === 'ONLINE_BANKING') {
                    onlineBankingDetails.classList.add('active');
                } else if (method === 'CASH') {
                    cashPaymentDetails.classList.add('active');
                }
            });
        });
        
        // 表单验证
        function validateForm() {
            const selectedMethod = paymentMethodInput.value;
            
            if (!selectedMethod) {
                alert('Please select a payment method');
                return false;
            }
            
            if (selectedMethod === 'CREDIT_CARD' || selectedMethod === 'DEBIT_CARD') {
                const cardHolderName = document.querySelector('input[name="cardHolderName"]').value;
                const cardNumber = document.querySelector('input[name="cardNumber"]').value;
                const expiryDate = document.querySelector('input[name="expiryDate"]').value;
                const cvv = document.querySelector('input[name="cvv"]').value;
                
                if (!cardHolderName || !cardNumber || !expiryDate || !cvv) {
                    alert('Please fill in all card information');
                    return false;
                }
                
                // Validate card number format
                if (!/^\d{4}(\s\d{4}){3}$|^\d{16}$/.test(cardNumber.trim())) {
                    alert('Please enter a valid 16-digit card number');
                    return false;
                }
                
                // Validate expiry date format
                if (!/^\d{2}\/\d{2}$/.test(expiryDate)) {
                    alert('Please enter a valid expiry date (MM/YY)');
                    return false;
                }
                
                // Validate CVV format
                if (!/^\d{3}$/.test(cvv)) {
                    alert('Please enter a valid 3-digit CVV code');
                    return false;
                }
            } else if (selectedMethod === 'E_WALLET') {
                const eWalletType = document.querySelector('select[name="eWalletType"]').value;
                const eWalletAccount = document.querySelector('input[name="eWalletAccount"]').value;
                
                if (!eWalletType || !eWalletAccount) {
                    alert('Please fill in all e-wallet information');
                    return false;
                }
            } else if (selectedMethod === 'ONLINE_BANKING') {
                const bankName = document.querySelector('select[name="bankName"]').value;
                const bankAccountNumber = document.querySelector('input[name="bankAccountNumber"]').value;
                
                if (!bankName || !bankAccountNumber) {
                    alert('Please fill in all online banking information');
                    return false;
                }
                
                // 验证银行账号格式
                if (!/^\d{10,16}$/.test(bankAccountNumber.trim())) {
                    alert('Please enter a valid bank account number');
                    return false;
                }
            }
            
            return confirm('Confirm payment?');
        }
        
        // 格式化卡号输入
        const cardNumberInput = document.querySelector('input[name="cardNumber"]');
        if (cardNumberInput) {
            cardNumberInput.addEventListener('input', function(e) {
                let value = e.target.value.replace(/\D/g, '');
                let formattedValue = '';
                
                for (let i = 0; i < value.length; i++) {
                    if (i > 0 && i % 4 === 0) {
                        formattedValue += ' ';
                    }
                    formattedValue += value[i];
                }
                
                e.target.value = formattedValue;
            });
        }
        
        // 格式化有效期输入
        const expiryDateInput = document.querySelector('input[name="expiryDate"]');
        if (expiryDateInput) {
            expiryDateInput.addEventListener('input', function(e) {
                let value = e.target.value.replace(/\D/g, '');
                
                if (value.length > 2) {
                    e.target.value = value.substring(0, 2) + '/' + value.substring(2, 4);
                } else {
                    e.target.value = value;
                }
            });
        }
    </script>
</body>
</html>

<!-- 在页面底部添加JavaScript代码 -->
<script>
    document.getElementById('discountCode').addEventListener('change', function() {
        var discountCode = this.value;
        var discountAmount = 0;
        var discountRow = document.getElementById('discountRow');
        var discountDisplay = document.getElementById('discountDisplay');
        
        // 根据选择的折扣代码设置折扣金额
        switch(discountCode) {
            case 'SUMMER25':
                discountAmount = 25;
                break;
            case 'WELCOME15':
                discountAmount = 15;
                break;
            case 'HOLIDAY30':
                discountAmount = 30;
                break;
            case 'FLASH50':
                discountAmount = 50;
                break;
            case 'BDAY20':
                discountAmount = 20;
                break;
            case 'SKINCARE10':
                discountAmount = 10;
                break;
            default:
                discountAmount = 0;
        }
        
        // 设置折扣金额到隐藏字段
        document.getElementById('discountAmount').value = discountAmount;
        
        // 显示或隐藏折扣行
        if (discountAmount > 0) {
            discountRow.style.display = 'flex';
            discountDisplay.value = '- RM ' + discountAmount.toFixed(2);
            document.getElementById('discountMessage').textContent = 'Apply discount: - RM ' + discountAmount.toFixed(2);
        } else {
            discountRow.style.display = 'none';
            discountDisplay.value = '';
            document.getElementById('discountMessage').textContent = '';
        }
        
        // 重新计算总金额
        updateTotalWithDiscount(discountAmount);
    });
    
    // 更新总金额函数
    // 更新总金额函数
    function updateTotalWithDiscount(discountAmount) {
        var subtotalInput = document.getElementById('subtotal');
        var shippingInput = document.getElementById('shipping');
        var taxInput = document.getElementById('tax');
        var totalDisplay = document.getElementById('total');
        var finalTotalInput = document.getElementById('finalTotal');
        
        // 确保正确解析金额，移除"RM "前缀和千位分隔符
        var subtotal = parseFloat(subtotalInput.value.replace('RM ', '').replace(/,/g, ''));
        var shipping = shippingInput.value.includes('Free') ? 0 : parseFloat(shippingInput.value.replace('RM ', '').replace(/,/g, ''));
        var tax = parseFloat(taxInput.value.replace('RM ', '').replace(/,/g, ''));
        
        // 计算折扣后的总金额
        var total = subtotal + shipping + tax - discountAmount;
        if (total < 0) total = 0; // 防止负数
        
        // 更新显示
        totalDisplay.textContent = 'RM ' + total.toFixed(2);
        finalTotalInput.value = 'RM ' + total.toFixed(2);
        
        // 存储折扣金额到隐藏字段
        document.getElementById('discountAmount').value = discountAmount.toFixed(2);
    }
</script>