% CPNDATEPQ �m�藘�t�̑O��̏��N�[�|����
%
% ���̊֐��́ANUMBONDS �̊m�藘�t�̑O�񏀃N�[�|�������o�͂��܂��B
% �O�񏀃N�[�|�����́A�m�藘�t�ɂ��āA�W���N�[�|�����Ԃ̒�����
% ���肵�܂��B�������A�O�񏀃N�[�|�������K���������ۂ̃N�[�|���x������
% ��v����Ƃ͌���܂���B���̊֐��́A�ŏ��A�܂��͍Ō�̃N�[�|���x��
% �܂ł̊��Ԃ̒��Z�Ɋւ�炸�A�O�񏀃N�[�|�������o�͂��܂��B
%
%   PreviousQuasiCouponDate = cpndatepq(Settle, Maturity)
%
%   PreviousQuasiCouponDate = cpndatepq(Settle, Maturity, Period, Basis, 
%                                   EndMonthRule, IssueDate, FirstCouponDate,
%                                   LastCouponDate)
% ����: 
%     Settle - ���ϓ�
%     Maturity - ������
%
% �I�v�V�����̓���:
%     Period - �N������̃N�[�|����; �f�t�H���g�� 2 (���N����)
%     Basis - �����̃J�E���g�; �f�t�H���g�� 0 (actual/actual)
%     EndMonthRule - �����K��; �f�t�H���g�� 1 (�����K���͗L��)
%     IssueDate - ���s��
%     FirstCouponDate - �ŏ��̃N�[�|����
%     LastCouponDate - �Ō�̃N�[�|����
%
% �o��: 
%     PreviousQuasiCouponDate - ���ϓ��ȑO�̑O�񏀃N�[�|��������Ȃ�
%     NUMBONDS�s1��̃x�N�g���ł��B���ϓ����N�[�|�����Ɠ���̏ꍇ�A
%     ���̊֐��͌��ϓ����o�͂��܂��B
%
% ����:
%     �K�{�̈����́ANUMBONDS�s1��A�܂��� 1�sNUMBONDS��̃x�N�g���A�܂���
%     �X�J�������łȂ���΂Ȃ�܂���B�I�v�V�����̈����́ANUMBONDS�s1��A
%     �܂��́A1�sNUMBONDS��̃x�N�g���A�X�J���A�܂��͋�s��łȂ����
%     �Ȃ�܂���B�l�̎w��̂Ȃ����͂ɂ� NaN ����̓x�N�g���Ƃ��Đݒ肵��
%     ���������B���t�̓V���A�����t�ԍ��A�܂��͓��t������ł��B
%  
%     ���ꂼ��̓��͈����y�яo�͈����̏ڍׂɂ��ẮA�R�}���h���C�����
%     'help ftb' + ������ (���Ƃ��΁ASettle (���ϓ�) �Ɋւ���w���v�́A
%     "help ftbSettle") �ƃ^�C�v���ē����܂��B
%
% �Q�l CPNDATEN, CPNDATENQ, CPNDATEP, CPNDAYSN, CPNDAYSP, CPNPERSZ, 
%      CPNCOUNT, CFDATES, CFAMOUNTS, ACCRFRAC, CFTIMES.     


% Copyright 1995-2006 The MathWorks, Inc.
