# ServExcel
[![GitHub stars](https://img.shields.io/github/stars/ahmedwagehfawzy08/ServExcel?style=social)](https://github.com/ahmedwagehfawzy08/ServExcel/stargazers)
[![GitHub forks](https://img.shields.io/github/forks/ahmedwagehfawzy08/ServExcel?style=social)](https://github.com/ahmedwagehfawzy08/ServExcel/network/members)
[![License](https://img.shields.io/github/license/ahmedwagehfawzy08/ServExcel)](https://github.com/ahmedwagehfawzy08/ServExcel/blob/main/LICENSE)

<p align="center">
  <img src="LOGO.png" alt="ServExcel Logo" width="200"/>
</p>

## 🎥 Project Demo

<p align="center">
  <img src="video.gif" alt="ServExcel Demo Video" width="600"/>
</p>

## 📝 Project Description

**ServExcel** is an advanced Retrieval Augmented Generation (RAG) system specifically designed to work with Excel files, transforming them into intelligent, queryable knowledge bases. The project allows users to ask natural language questions and receive accurate answers extracted directly from complex Excel spreadsheet data, facilitating information access without requiring advanced programming or analytical skills.

## ✨ App Interface

<p align="center">
  <img src="1.png" alt="Main Screen" width="400"/>
</p>

## 🚀 Key Features

- ✅ **Intelligent Excel Processing**: Automatically convert any Excel file into a searchable knowledge base
- ✅ **Natural Conversation Interface**: Ask questions in simple language and get accurate answers
- ✅ **Data Visualization**: Display retrieved data in easy-to-understand visual formats
- ✅ **Complex Calculation Support**: Perform advanced calculations on extracted data
- ✅ **Customization and Integration**: Easily integrate the system with other applications and systems
- ✅ **Multilingual Support**: Support for English, Arabic, and other languages
- ✅ **Export and Share**: Export results in multiple formats and share them easily

## 🛠️ Technologies Used

<p align="center">
  <img src="https://img.shields.io/badge/Python-3776AB?style=for-the-badge&logo=python&logoColor=white" alt="Python"/>
  <img src="https://img.shields.io/badge/PyTorch-EE4C2C?style=for-the-badge&logo=pytorch&logoColor=white" alt="PyTorch"/>
  <img src="https://img.shields.io/badge/Transformers-FFD700?style=for-the-badge&logo=huggingface&logoColor=black" alt="Transformers"/>
  <img src="https://img.shields.io/badge/FastAPI-009688?style=for-the-badge&logo=fastapi&logoColor=white" alt="FastAPI"/>
  <img src="https://img.shields.io/badge/React-61DAFB?style=for-the-badge&logo=react&logoColor=black" alt="React"/>
  <img src="https://img.shields.io/badge/React_Native-61DAFB?style=for-the-badge&logo=react&logoColor=black" alt="React Native"/>
  <img src="https://img.shields.io/badge/Pandas-150458?style=for-the-badge&logo=pandas&logoColor=white" alt="Pandas"/>
</p>

## 📋 Requirements

- Python 3.8+
- Compatible CUDA (for GPU acceleration - optional but recommended)
- At least 8GB RAM (16GB recommended for large files)
- Node.js and npm for the frontend

## ⚙️ Installation

```bash
# Clone the project
git clone https://github.com/ahmedwagehfawzy08/ServExcel.git

# Navigate to the project directory
cd ServExcel

# Create and activate a virtual environment
python -m venv venv
source venv/bin/activate  # For Linux/Mac
# or
venv\Scripts\activate  # For Windows

# Install requirements
pip install -r requirements.txt

# Run the project
python run.py
```

## 📷 Screenshots

<div align="center">
  <div style="display: flex; justify-content: space-between; margin-bottom: 20px;">
    <img src="2.png" alt="Sign In" width="30%"/>
    <img src="3.png" alt="Sign Up" width="30%"/>
    <img src="4.png" alt="Features" width="30%"/>
  </div>
  <div style="display: flex; justify-content: space-between; margin-bottom: 20px;">
    <img src="5.png" alt="AI Assistant" width="30%"/>
    <img src="6.png" alt="Excel Analysis" width="30%"/>
    <img src="7.png" alt="Chat Interface" width="30%"/>
  </div>
</div>

## 🔄 Project Structure

```mermaid
flowchart TD
    A[User] -->|Uploads Excel File| B[File Processor]
    B -->|Extracts Data| C[Vector Knowledge Base]
    A -->|Asks Question| D[Natural Language Processor]
    D -->|Analyzes Query| E{Search Engine}
    E -->|Searches in| C
    C -->|Retrieves Relevant Documents| F[Answer Generator]
    F -->|Creates Answer| G[Visual Renderer]
    G -->|Displays Results| A
```

## 🌟 Use Cases

- **Financial Analysis**: Extract insights and trends from complex financial data
- **Inventory Management**: Track and analyze inventory and sales data
- **Executive Reporting**: Create summaries and reports from large datasets
- **Statistical Analysis**: Perform complex statistical operations with simple commands
- **Decision Support**: Extract information to support strategic decision-making

## 🔒 Security and Privacy

ServExcel ensures complete data privacy with local file processing. Data is not stored on external servers, and all files are encrypted during processing.

## 🙏 Acknowledgements

Thanks to all contributors to this project and the open-source libraries that were used.