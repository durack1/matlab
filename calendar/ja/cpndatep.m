% CPNDATEP �m�藘�t�̑O��̃N�[�|����
%
% ���̊֐��́ANUMBONDS �̊m�藘�t�̑O��̃N�[�|�������o�͂��܂��B
% ���̊֐��́A�ŏ��A�܂��͍Ō�̃N�[�|���܂ł̊��Ԃ̒��Z�Ɋւ�炸�A
% ���̑O��̃N�[�|�������o�͂��܂��B�[���N�[�|���ɂ��ẮA
% ���������o�͂��܂��B
%
%   PreviousCouponDate = cpndatep(Settle, Maturity)
%
%   PreviousCouponDate = cpndatep(Settle, Maturity, Period, Basis, 
%                             EndMonthRule, IssueDate, FirstCouponDate,
%                             LastCouponDate)
% ����: 
%     Settle - ���ϓ�
%     Maturity - ������
%
% �I�v�V�����̓���:
%     Period - �N������̃N�[�|���x����; �f�t�H���g�� 2 (���N����)
%     Basis - �����̃J�E���g�; �f�t�H���g�� 0 (actual/actual)
%     EndMonthRule - �����K��; �f�t�H���g�� 1 (�����K���͗L��)
%     IssueDate - ���s��
%     FirstCouponDate - �ŏ��̃N�[�|����
%     LastCouponDate - �Ō�̃N�[�|����
%
% �o��: 
%     PreviousCouponDate - ���ϓ��y�т���ȑO�ɓ����������ۂ̑O��N�[�|����
%     ����Ȃ� NUMBONDS�s1�� �̃x�N�g���ł��B���ϓ����N�[�|�����Ɠ���̏ꍇ�A
%     ���̊֐��͌��ϓ����o�͂��܂��B���Ȃ킿�A�����Ɍ��ϓ��A�܂��͂���
%     �ȑO�̎��ۂ̃N�[�|���������̊֐��͏o�͂��܂����A�O��N�[�|������
%     ���s���ȑO�ƂȂ�ꍇ�� (���ꂪ�A���Ƃ����p�\�ł������Ƃ��Ă�)
%     ���O���܂��B���̂��߁A���̊֐��͎��ۂ̔��s���A�܂��͌��ϓ������
%     �����O��N�[�|�����̂����ꂩ�߂��ق��̓��t���o�͂��܂��B
%
% ����:
%     �K�{�̈����́ANUMBONDS�s1��A�܂��́A1�sNUMBONDS��̃x�N�g���A�܂���
%     �X�J���łȂ���΂Ȃ�܂���B�I�v�V�����̈����́ANUMBONDS�s1��A�܂��́A
%     1�sNUMBONDS��̃x�N�g���A�X�J���A�܂��͋�s��łȂ���΂Ȃ�܂���B
%     �l�̎w��̂Ȃ����͂ɂ� NaN ����̓x�N�g���Ƃ��Đݒ肵�Ă��������B
%     ���t�́A�V���A�����t�ԍ��A�܂��͓��t������ł��B
%
%     ���ꂼ��̓��͈����y�яo�͈����̏ڍׂɂ��ẮA�R�}���h���C�����
%     'help ftb' + ������ (���Ƃ��΁ASettle (���ϓ�) �Ɋւ���w���v�́A
%     "help ftbSettle") �ƃ^�C�v���ē����܂��B
%
% �Q�l CPNDATEPQ, CPNDATEN, CPNDATENQ, CPNDAYSN, CPNDAYSP, CPNPERSZ, 
%      CPNCOUNT, CFDATES, CFAMOUNTS, ACCRFRAC, CFTIMES.


% Copyright 1995-2006 The MathWorks, Inc.
