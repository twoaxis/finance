import React from "react";
import styled from "styled-components";
import { RegisterForm } from "./RegisterForm";
const Wrapper = styled.div`
  display: flex;
  flex-direction: column;
  gap: 16px;
  width: 100%;
`;

export const RegisterCard: React.FC = () => {
  return (
    <Wrapper>
      <RegisterForm/>
    </Wrapper>
  );
};