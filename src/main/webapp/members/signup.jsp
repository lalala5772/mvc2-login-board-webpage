<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>회원가입</title>
<script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/@web3auth/modal@latest"></script>
<script
	src="https://cdn.jsdelivr.net/npm/ethers@5.7.2/dist/ethers.min.js"></script>

<style>
* {
	margin: 0;
	padding: 0;
	box-sizing: border-box;
}

body {
	font-family: 'Arial', sans-serif;
	background-color: #f5f5f5;
	display: flex;
	justify-content: center;
	align-items: center;
	min-height: 100vh;
	padding: 20px;
}

.signup-container {
	background-color: white;
	padding: 40px;
	border-radius: 10px;
	box-shadow: 0 0 20px rgba(0, 0, 0, 0.1);
	width: 100%;
	max-width: 500px;
}

.signup-title {
	text-align: center;
	margin-bottom: 30px;
	color: #333;
}

.form-group {
	padding: 10px;
	margin-bottom: 20px;
	border: 1px solid #ddd;
	border-radius: 5px;
}

.form-group legend {
	color: #555;
	font-weight: bold;
}

.form-group label {
	display: block;
	margin-bottom: 8px;
	color: #555;
	font-weight: bold;
}

.form-group input {
	width: 100%;
	padding: 12px;
	border: 1px solid #ddd;
	border-radius: 5px;
	font-size: 16px;
	transition: border-color 0.3s ease;
}

.form-group input:focus {
	outline: none;
	border-color: #4CAF50;
}

.form-group .address-inputs {
	display: flex;
	gap: 10px;
	margin-bottom: 10px;
}

.form-group .address-inputs input[type="text"] {
	flex: 1;
}

.form-group .address-inputs button {
	padding: 12px 20px;
	background-color: #4CAF50;
	color: white;
	border: none;
	border-radius: 5px;
	cursor: pointer;
	font-size: 16px;
}

.form-group .address-inputs button:hover {
	background-color: #45a049;
}

.submit-btn {
	width: 49%;
	padding: 15px;
	background-color: #4CAF50;
	color: white;
	border: none;
	border-radius: 5px;
	font-size: 16px;
	font-weight: bold;
	cursor: pointer;
	transition: background-color 0.3s ease;
}

.submit-btn:hover {
	background-color: #45a049;
}

#address1 {
	margin-bottom: 10px;
}

#pw-text {
	padding: 10px 0 0 0;
}

/* 반응형 디자인 */
@media ( max-width : 480px) {
	.signup-container {
		padding: 20px;
	}
	.form-group .address-inputs {
		flex-direction: column;
	}
	.form-group .address-inputs button {
		width: 100%;
	}
}

#duplCheck {
	padding: 0.5rem 1rem;
	border: none;
	color: #fff;
	cursor: pointer;
	border-radius: 4px;
}
</style>
</head>
<body>
	<c:if test="${not empty signupError}">
		<script>
			alert("${signupError}");
		</script>
	</c:if>

	<div class="signup-container">
		<h1 class="signup-title">회원가입</h1>
		<form id="signupForm" action="/signup.members" method="post">
			<fieldset class="form-group">
				<legend>아이디/패스워드</legend>

				<label for="userid">아이디</label> <input type="text" id="userid"
					name="userid" placeholder="아이디를 입력하세요">
				<button type="button" id="duplCheck" name="duplCheck"
					style="background-color: #6b63ff;">중복확인</button>

				<label for="password">비밀번호</label> <input type="password"
					id="password" name="password" placeholder="패스워드를 입력하세요"> <label
					for="password-confirm">비밀번호 확인</label> <input type="password"
					id="password-confirm" name="password-confirm"
					placeholder="패스워드를 다시 입력하세요">

				<p id="pw-text"></p>
			</fieldset>

			<fieldset class="form-group">
				<legend>이름/전화번호/이메일</legend>

				<label for="name">이름</label> <input type="text" id="name"
					name="name" placeholder="이름을 입력하세요"> <label for="phone">전화번호</label>
				<input type="tel" id="phone" name="phone"
					placeholder="010-0000-0000"> <label for="email">이메일</label>
				<input type="email" id="email" name="email" placeholder="이메일을 입력하세요">
			</fieldset>

			<fieldset class="form-group">
				<legend>주소</legend>
				<div class="address-inputs">
					<input type="text" id="postcode" name="postcode"
						placeholder="우편번호를 입력하세요" readonly>
					<button type="button" id="postcode-btn"
						style="background-color: #6b63ff" onclick="searchAddress()">우편번호
						찾기</button>
				</div>
				<input type="text" id="address1" name="address1"
					placeholder="주소를 입력하세요" readonly> <input type="text"
					id="address2" name="address2" placeholder="상세 주소를 입력하세요">
			</fieldset>

			<!-- metamask field 혼자 공부하는 내용 추가 -->

			<!-- Web3 지갑 주소 필드 (자동 생성) -->
			<!-- <fieldset class="form-group">
				<input type="hidden" id="walletAddress" name="walletAddress">

				<button type="button" onclick="createWallet()">Web3 지갑 생성</button>
				<input type="text" id="walletAddress" readonly />
				<button id="createWalletBtn" onclick="createWallet()" disabled>지갑
					생성</button>

			</fieldset>
			
 -->
			<fieldset class="form-group">
				<legend>메타마스크 지갑 연결</legend>
				<button type="button" id="connectWalletBtn" class="submit-btn"
					style="background-color: #ff9900;">메타마스크 지갑 연결</button>
				<input type="text" id="walletAddress" name="walletAddress"
					placeholder="지갑 주소가 여기에 표시됩니다" readonly>
			</fieldset>

			<button type="submit" class="submit-btn"
				style="background-color: #6b63ff">가입하기</button>
			<button type="reset" class="submit-btn" id="cancel_button"
				style="background-color: #6b63ff">초기화</button>
		</form>
	</div>
	<!-- <script>
        const clientId = "BC7glAWXGUMH7WqcTnfeSu77CI310im4EOS6ircgNn50k6_gJMuQEoguGbxhjvjnAFLsFEYqvLeLr7YHiViONYY";
        let web3auth;

        async function initWeb3Auth() {
            web3auth = new Web3Auth.Web3Auth({
                clientId: clientId,
                chainConfig: {
                    chainNamespace: "eip155",
                    chainId: "0x1" // Ethereum Mainnet
                }
            });

            await web3auth.initModal();
            document.getElementById("createWalletBtn").disabled = false;
            console.log("Web3Auth 초기화 완료");
        }

        async function createWallet() {
            if (!web3auth) {
                console.error("Web3Auth가 초기화되지 않았습니다.");
                return;
            }

            try {
                const provider = await web3auth.connect();
                const ethersProvider = new ethers.BrowserProvider(provider);
                const signer = await ethersProvider.getSigner();
                const address = await signer.getAddress();
                document.getElementById("walletAddress").value = address;
                alert("지갑이 성공적으로 생성되었습니다! 지갑 주소: " + address);
            } catch (error) {
                console.error("지갑 생성 실패:", error);
            }
        }

        window.addEventListener('load', initWeb3Auth);

        function isValidName(name) {
            const nameRegex = /^[가-힣]{2,5}$/;
            return name.trim().normalize('NFC').match(nameRegex) !== null;
        }

        function passwordCheck() {
            if (password.value === "" && passwordConfirm.value === "") {
                pwText.innerHTML = "";
                return;
            }

            if (password.value === passwordConfirm.value) {
                pwText.innerHTML = "비밀번호가 일치합니다.";
                pwText.setAttribute("style", "color:#45a049;");
            } else {
                pwText.innerHTML = "비밀번호가 일치하지 않습니다.";
                pwText.setAttribute("style", "color:red;");
            }
        }

        password.onkeyup = passwordCheck;
        passwordConfirm.onkeyup = passwordCheck;

        signupForm.onsubmit = function() {
            // 유효성 검사 로직 생략
        };

        function searchAddress() {
            if (typeof daum === 'undefined' || typeof daum.Postcode === 'undefined') {
                Swal.fire("주소 검색 서비스가 로드되지 않았습니다. 잠시 후 다시 시도해주세요.");
                return;
            }

            new daum.Postcode({
                oncomplete: function(data) {
                    document.getElementById("address1").value = data.address;
                    document.getElementById("postcode").value = data.zonecode;
                }
            }).open();
        }
    </script> -->
	<script>
		$("#duplCheck")
				.on(
						"click",
						function() {
							if ($("#userid").val() == "") {
								alert("ID를 먼저 입력하세요.");
								return;
							}

							window
									.open(
											"/idcheck.members?userid="
													+ $("#userid").val(),
											"idCheckWindow",
											"width=400,height=300,left=100,top=100,resizable=no,scrollbars=no,toolbar=no,menubar=no,location=no,status=no");
						});
		
		// 메타마스크 지갑 연결
		document.getElementById('connectWalletBtn').addEventListener('click', async () => {
    if (typeof window.ethereum !== 'undefined') {
        try {
            const accounts = await window.ethereum.request({ method: 'eth_requestAccounts' });
            document.getElementById('walletAddress').value = accounts[0];
            Swal.fire("메타마스크 지갑이 성공적으로 연결되었습니다!");
        } catch (error) {
            Swal.fire("지갑 연결에 실패했습니다. 다시 시도해주세요.");
        }
    } else {
        Swal.fire({
            icon: "error",
            title: "메타마스크가 설치되지 않았습니다.",
            html: "메타마스크를 설치한 후 다시 시도해주세요.<br><a href='https://metamask.io/download.html' target='_blank' style='color: #4CAF50; font-weight: bold;'>메타마스크 다운로드</a>",
            confirmButtonText: "확인"
        });
    }
});
		
	</script>

	<script>
		let userid = document.getElementById("userid");
		let password = document.getElementById("password");
		let passwordConfirm = document.getElementById("password-confirm");
		let pwText = document.getElementById("pw-text");
		let postcode = document.getElementById("postcode");
		let postcodeBtn = document.getElementById("postcode-btn");
		let address1 = document.getElementById("address1");
		let cancelButton = document.getElementById("cancel_button");
		let name = document.getElementById("name");
		let phone = document.getElementById("phone");
		let email = document.getElementById("email");

		// 비밀번호 일치 확인 
		function passwordCheck() {
			if (password.value == passwordConfirm.value) {
				pwText.innerHTML = "비밀번호가 일치합니다."
				pwText.setAttribute("style", "color:#45a049;");

				if (password.value == "" && passwordConfirm.value == "") {
					pwText.innerHTML = "";
				}
			} else {
				pwText.innerHTML = "비밀번호가 일치 하지 않습니다."
				pwText.setAttribute("style", "color:red;");
			}
		}

		password.onkeyup = passwordCheck;
		passwordConfirm.onkeyup = passwordCheck;

		// 유효성검사 
		let signupForm = document.getElementById("signupForm");
		signupForm.onsubmit = function() {
			// 공백 확인
			if (userid.value.trim() === "") {
				Swal.fire("ID는 필수 입력 사항 입니다.");
				userid.focus();
				return false;
			}
			if (password.value.trim() === ""
					|| passwordConfirm.value.trim() === "") {
				Swal.fire("패스워드는 필수 입력 사항 입니다.");
				password.focus();
				return false;
			}
			if (password.value !== passwordConfirm.value) {
				Swal.fire({
					icon : "error",
					title : "Oops...",
					text : "패스워드가 일치하지 않습니다.",
				});
				password.focus();
				return false;
			}

			function isValidName(name) {
				const nameRegex = /^[가-힣]{2,5}$/;
				return name.trim().normalize('NFC').match(nameRegex) !== null;
			}

			// 양식 확인
			const pwRegex = /^(?=.*[A-Z])(?=.*[a-z])(?=.*\d).{8,}$/;
			const phonNumRegex = /^010[- ]?\d{4}[- ]?\d{4}$/;
			const emailRegex = /(\w+@\w+.\w+$)|(\w+@\w+.\w+\w+$)/;

			
			if (!pwRegex.test(password.value)) {
				Swal.fire("Password는 대문자,소문자,숫자를 포함하여 8자 이상으로 입력해주세요.");
				return false;
			}
			if (!isValidName(name.value)) {
				Swal.fire("이름은 한글 2~5자로 입력해주세요.");
				return false;
			}
			if ((phone.value.trim() !== "")
					&& !phonNumRegex.test(phone.value.trim())) {
				Swal.fire("전화번호 형식을 확인해주세요.");
				return false;
			}
			if ((email.value.trim() !== "")
					&& !emailRegex.test(email.value.trim())) {
				Swal.fire("이메일 형식을 확인해주세요.");
				return false;
			}
		};
		/* 중복체크하는 순간 팝업 띄우는 함수 추가 */
		/* ssr 방식으로 할 수 있는 최선  */
	</script>


	<script>
		function searchAddress() {
			new daum.Postcode({
				oncomplete : function(data) {
					document.getElementById("address1").value = data.address;
					document.getElementById("postcode").value = data.zonecode;
				}
			}).open();
		}
	</script>
	<script
		src="//t1.daumcdn.net/mapjsapi/bundle/postcode/prod/postcode.v2.js"></script>
</body>

</html>