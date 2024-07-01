# Plutus Course 2024

Khóa học Lập trình Hợp đồng Thông minh Plutus là một hướng dẫn toàn diện từ cơ bản đến nâng cao, tập trung vào việc phát triển kỹ năng lập trình trong môi trường blockchain của Cardano. Dưới đây là giới thiệu nội dung của khóa học:

## Chương 1: Mở Đầu
### 1.1 Giới Thiệu về Plutus
Plutus là một nền tảng hợp đồng thông minh trên Blockchain Cardano.
Cấu trúc Plutus bao gồm Plutus Platform, Plutus TX, Plutus Core.
Phân tích cấu trúc cơ bản của một Smart Contract Plutus.
### 1.2 Vai Trò của UPLC trong Ứng Dụng Phi Tập Trung
Hiểu về UPLC, CBOR, và Validator trong môi trường phi tập trung.
### 1.3 UTXO Model và Smart Contract
Giới thiệu về UTXO Model và cách nó kết hợp với Smart Contracts eUTXO.
### 1.4 Hashing & Digital Signatures
Hiểu về băm và chữ ký số trong Blockchain.

## Chương 2: Cài Đặt Trình Biên Dịch Hợp Đồng Thông Minh Plutus
### 2.1 Môi trường Biên Dịch Plutus với Demeter.run
Hướng dẫn cách tạo và biên dịch một Plutus Script sử dụng Demete.run.
### 2.2 Thiết Lập Môi Trường Biên Dịch Plutus với Docker
Tạo môi trường biên dịch Plutus với Docker trên các hệ điều hành Ubuntu và Windows.
### 2.3 Thiết Lập Môi Trường Biên Dịch Plutus Cục Bộ
Tạo môi trường phát triển Plutus bằng Nix Shell và thực hiện biên dịch trên Ubuntu và Windows.

## Chương 3: Tương Tác với Blockchain Cardano – Mạng Thử Nghiệm Preview
### 3.1 Giới Thiệu Cardano-node
Hiểu về Cardano-node và vai trò của nó trong mạng Cardano.
### 3.2 Cài Đặt Node Cardano với Mạng Thử Nghiệm Preview
Hướng dẫn cách cài đặt Cardano-node và demo trên mạng thử nghiệm Preview.
### 3.3 Wallet và Địa Chỉ
Tạo ví bằng câu lệnh như thế nào?
Giới thiệu về cặp khóa (công khai+riêng tư)
Giới thiệu về địa chỉ ví chi tiêu
Giới thiệu về địa chỉ ví stake
Giới thiệu về địa chỉ hợp đồng thông minh
### 3.4 Tạo Ví và Nhận tADA bằng Ví Nami
Tạo ví trên mạng thử nghiệm Preview và nhận tADA, bảo mật thông tin các từ khôi phục và thực hiện giao dịch.
### 3.5 Khôi Phục Ví bằng Dòng Lệnh CLI
Khôi phục ví bằng Command Line Interface từ cụm từ khôi phục.
### 3.6 Tương Tác và Giao Dịch  với Cardano qua Full Node – Cardano-cli
Giới thiệu Cardano-cli và thực hiện các truy vấn cơ bản.
Hướng dẫn xây dựng và tạo một giao dịch đơn giản và các bước thực hiện giao dịch.
### 3.7 Tạo giao dịch khóa tài sản với hợp đồng thông minh Alwaysucceed qua Cardano-cli    
Khóa một token vào hợp đồng thông minh bằng Cardano-cli
### 3.8 Tạo giao dịch mở khóa tài sản với hợp đồng thông minh Alwaysucceed qua Cardano-cli    
Mở khóa token từ hợp đồng thông minh bằng Cardano-cli
### 3.9 Sử Dụng Bash Script để Tạo Giao Dịch
Tạo file script shell để tự động hóa lệnh Cardano-cli.

## Chương 4: Tương Tác với Blockchain Cardano bằng Lucid – Trình Duyệt
### 4.1 Tạo giao dịch đơn giản
### 4.2 Tạo Native Tokens
### 4.3 Mint và Burn NFT

## Chương 5: Viết Trình Xác Thực Plutus Đơn Giản và Tương Tác với Mã On-Chain – Sử Dụng Cardano-cli
### 5.1 Tổng quan về validator bậc thấp, bậc cao    
### 5.2 Validator bậc thấp    
### 5.3 Validator bậc cao     
### 5.4 Sử dụng cardano-cli tương tác với các Plutus script    

## Chương 6: Viết Trình Xác Thực Plutus Nâng Cao và Tương Tác với Mã On-Chain – Sử Dụng Giao Diện Web
### 6.1 Mô hình eUTxO thể hiện trong Plutus    
### 6.2 Viết hợp đồng thông minh sử dụng Datum và Redeemer    
### 6.3 Script Contexts    
### 6.4 Handling Time    
### 6.5 Viết hợp đồng thông minh “Vesting”    
### 6.6 Viết hợp đồng thông minh có tham số hóa “Parameterized Contracts”    
### 6.7 Tương tác với Hợp đồng thông minh với mã Off-Chain của Lucid    
### 6.8 Tương tác với Hợp đồng thông minh với mã Off-Chain của Lucid dùng “Reference Scripts”

## Chương 7: So Sánh Mã On-Chain và Off-Chain; Một Số SDK Cho Mã Off-Chain
### 7.1 On-Chain Vs. Off-Chain Code    
### 7.2 Off-Chain Code with Cardano CLI and GUI    
### 7.3 Off-chain Code with Kuber    
### 7.4 Off-chain Code with Lucid

## Chương 8: Native Tokens
### 8.1 Giới thiệu về Native Tokens    
Tìm hiểu chi tiết về Native Tokens và cách chúng hoạt động trong môi trường Cardano.
### 8.2 Kiểu dữ liệu Value
### 8.3 Chính sách đúc tiền đơn giản  
### 8.4 Chính sách đúc tiền có tính thực tế hơn    
### 8.5 Token không thể thay thế (NFT) trên Cardano
