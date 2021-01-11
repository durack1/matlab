%M2XDATE  MATLAB �V���A���ԍ����t�� Excel �V���A���ԍ����t�ɕϊ�
%
%   DateNumber = m2xdate(MATLABDateNumber, Convention)
%
%   �ڍׁF���̊֐��́AMATLAB �V���A���ԍ����t������ Excel �V���A���ԍ�
%         ���t�����ɕϊ����܂��B
%
%   ����:   MATLABDateNumber - MATLAB �V���A���ԍ����t�ŕ\�����ꂽ�V���A��
%           ���t�ԍ��� Nx1 �܂��� 1xN �̃x�N�g���ł��B
%           Convention -  MATLAB �V���A���ԍ����t����ϊ����s���ۂɁA�ǂ� 
%           Excel �V���A���ԍ����t�ϊ��K����p���邩������ Nx1 �܂��� 1xN ��
%           �x�N�g���A�܂��́A�X�J���̃t���O�l�ł��B�ȉ��̒l��ݒ肵�܂��B
%           a) Convention = 0 - �V���A���ԍ����t 1 ���A1899 �N 12 �� 31 ����
%                �Ή����� 1900 ���t�V�X�e�� (�f�t�H���g)
%           b) Convention = 1 - �V���A���ԍ����t 0 ���A1904 �N 1 �� 1 ����
%                �Ή����� 1904 ���t�V�X�e��
%
%   �o��: Excel �̃V���A�����t�̔ԍ��`���� Nx1 �܂��� 1xN �̃V���A���ԍ�
%         ���t�̃x�N�g���B
%
%
%   ��: StartDate = 729706
%            Convention = 0;
%
%            EndDate = m2xdate(StartDate, Convention);
%
%            �́A�ȉ���Ԃ��܂��B
%
%            EndDate = 35746
%
%   ���ӁF Excel �̃o�O�̂��� (Excel 2003 SP1 �܂ł̓o�O����)�AExcel �ł� 
%          1900 �N�͂��邤�N�Ƃ��ď�������܂��B���ʂƂ��āA1900 �N 1 �� 1 ������ 
%          1900 �N 2 �� 28 ���܂ł̓��t�́A�֐� M2XDATE �ɂ���� 1 �Ⴄ�l��
%          �񍐂���܂��B
%
%         ��:
%                     Excel �ł́A 1900 �N 1 �� 1 �� = 1
%                     MATLAB �ł́A1900 �N 1 �� 1 �� = 2
%
%   �Q�l X2MDATE.


%   Copyright 1995-2008 The MathWorks, Inc.
