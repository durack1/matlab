% ACCRFRAC ���ϑO�̃N�[�|�����Ԃ̒[��
%
% ���̊֐��́ANBONDS �̊m�藘�t�ɑ΂��āA���ϓ��܂łɌo�߂���N�[�|��
% ���Ԃ̒[�����v�Z���܂��B�����Ōv�Z���ꂽ�[�����w�肳�ꂽ�m�藘�t��
% ����L���b�V���t���[�̖��ڊz�Ɗ|�����킹�邱�Ƃɂ���āA���Y���Ɏx��
% ����o�ߗ��q���Z�o���邱�Ƃ��ł��܂��B���̊֐��́A�ʏ�̃N�[�|������
% ���������1��ځA�܂��͍ŏI�N�[�|�����Ԃ̒������[���̍��̌o�ߗ��q
% �ɑ΂��Ă��L���ł��B
%
%   Fraction = accrfrac(Settle, Maturity)
%   Fraction = accrfrac(Settle, Maturity, Period)
%   Fraction = accrfrac(Settle, Maturity, Period, Basis)
%   Fraction = accrfrac(Settle, Maturity, Period, Basis, EndMonthRule)
%   Fraction = accrfrac(Settle, Maturity, Period, Basis, EndMonthRule, ...
%          IssueDate)
%   Fraction = accrfrac(Settle, Maturity, Period, Basis, EndMonthRule, ...
%          IssueDate, FirstCouponDate)
%   Fraction = accrfrac(Settle, Maturity, Period, Basis, EndMonthRule, ...
%          IssueDate, FirstCouponDate, LastCouponDate)
%   Fraction = accrfrac(Settle, Maturity, Period, Basis, EndMonthRule, ...
%          IssueDate, FirstCouponDate, LastCouponDate, StartDate)
%
%   Optional Inputs: Period, Basis, EndMonthRule, IssueDate,
%                    FirstCouponDate, LastCouponDate, StartDate
%
% ����:
%   ���� (�K�{) �́ANBONDS�s1��̃x�N�g���A�܂��̓X�J�������ł��B�I�v�V������
%   ���͂́A��s��ɂ���ďȗ����邱�Ƃ��ł��܂��B�܂��A�������X�g�̌㔼�̃I�v�V����
%   ���͂́A�A������ꍇ�A�ȗ����邱�Ƃ��ł��܂��B�I�v�V�����̓��͂̂����ꂩ�� 
%   NaN ��ݒ肷��ƁA�f�t�H���g�l���ݒ肳��܂��B���t�����́A�V���A�����t�ԍ��A
%   �܂��͓��t������ł��BSIA �m�藘�t�̈����̏ڍׂ�����ɂ́A'help ftb' ��
%   �^�C�v���Ă��������B�������̈����Ɋւ���ڍׁA���Ƃ��΁ASettle �Ɋւ���
%   �w���v�́A"help ftbSettle" �Ɠ��͂���ΎQ�Ƃł��܂��B
%
%       Settle          - ���ϓ�
%       Maturity        - ������
%
% �I�v�V�����̓���:
%       Period          - �N������̃N�[�|���񐔁B�f�t�H���g�� 2 (���N����)
%       Basis           - �����J�E���g��B�f�t�H���g�� 0 (Actual/Actual)
%       EndMonthRule    - �����K���B�f�t�H���g�� 1 (�����K���L��)
%       IssueDate       - ���s���B�o�ߗ����̌v�Z�J�n���B
%       FirstCouponDate - �ŏ��̃N�[�|���x�����B
%       LastCouponDate  - �Ō�ɃN�[�|���x�����B
%       StartDate       - (�������p�\��̂��߂̈���)
%
% �o��:
%       Fraction        - �o�ߗ����̊�����\�킷�x�N�g���B
%
% �Q�l CFAMOUNTS, CPNDATEN, CPNDATENQ, CPNDATEP, CPNDATEPQ, CPNDAYSN,
%      CPNDAYSP, CPNPERSZ, CPNCOUNT, CFDATES.


% Copyright 1995-2006 The MathWorks, Inc.
